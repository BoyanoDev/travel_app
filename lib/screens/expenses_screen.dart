import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import '../providers/expenses_provider.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends ConsumerWidget {
  final Trip trip;

  const ExpensesScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider(trip.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Gastos — ${trip.nombre}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (expenses) {
          final total = expenses.isEmpty
              ? 0.0
              : expenses.map((e) => e.importe).reduce((a, b) => a + b);

          return Column(
            children: [
              // Tarjeta resumen total
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text('Total gastado', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      '${total.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${expenses.length} gastos registrados',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),

              // Lista de gastos
              Expanded(
                child: expenses.isEmpty
                    ? const Center(child: Text('No hay gastos registrados'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return Dismissible(
                            key: Key(expense.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) {
                              ref
                                  .read(expensesProvider(trip.id).notifier)
                                  .removeExpense(expense.id);
                            },
                            child: ExpenseCard(expense: expense),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(trip: trip),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final Expense expense;

  const ExpenseCard({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _colorCategoria(expense.categoria),
          child: Icon(
            _iconoCategoria(expense.categoria),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(expense.descripcion),
        subtitle: Text(
          '${expense.categoria.name} · ${expense.fecha.day}/${expense.fecha.month}/${expense.fecha.year}',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Text(
          '${expense.importe.toStringAsFixed(2)} ${expense.moneda}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }

  Color _colorCategoria(ExpenseCategory categoria) {
    switch (categoria) {
      case ExpenseCategory.transporte:
        return Colors.blue;
      case ExpenseCategory.alojamiento:
        return Colors.purple;
      case ExpenseCategory.comida:
        return Colors.orange;
      case ExpenseCategory.ocio:
        return Colors.green;
      case ExpenseCategory.compras:
        return Colors.pink;
      case ExpenseCategory.otros:
        return Colors.grey;
    }
  }

  IconData _iconoCategoria(ExpenseCategory categoria) {
    switch (categoria) {
      case ExpenseCategory.transporte:
        return Icons.directions_car;
      case ExpenseCategory.alojamiento:
        return Icons.hotel;
      case ExpenseCategory.comida:
        return Icons.restaurant;
      case ExpenseCategory.ocio:
        return Icons.celebration;
      case ExpenseCategory.compras:
        return Icons.shopping_bag;
      case ExpenseCategory.otros:
        return Icons.more_horiz;
    }
  }
}
