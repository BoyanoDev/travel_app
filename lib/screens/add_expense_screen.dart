import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import '../providers/expenses_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final Trip trip;

  const AddExpenseScreen({super.key, required this.trip});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _descripcionController = TextEditingController();
  final _importeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ExpenseCategory _categoriaSeleccionada = ExpenseCategory.otros;
  String _monedaSeleccionada = 'EUR';
  DateTime _fecha = DateTime.now();
  bool _isLoading = false;

  final List<String> _monedas = ['EUR', 'USD', 'GBP', 'JPY', 'CHF'];

  @override
  void dispose() {
    _descripcionController.dispose();
    _importeController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (fecha != null) setState(() => _fecha = fecha);
  }

  Future<void> _guardarGasto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final gasto = Expense(
      id: '',
      tripId: widget.trip.id,
      descripcion: _descripcionController.text.trim(),
      importe: double.parse(_importeController.text.replaceAll(',', '.')),
      moneda: _monedaSeleccionada,
      categoria: _categoriaSeleccionada,
      fecha: _fecha,
    );

    await ref.read(expensesProvider(widget.trip.id).notifier).addExpense(gasto);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Gasto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej: Cena en restaurante',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _importeController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Importe',
                      prefixIcon: Icon(Icons.euro),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Introduce un importe';
                      }
                      final parsed = double.tryParse(
                        value.replaceAll(',', '.'),
                      );
                      if (parsed == null || parsed <= 0) {
                        return 'Importe no válido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: _monedaSeleccionada,
                    decoration: const InputDecoration(
                      labelText: 'Moneda',
                      border: OutlineInputBorder(),
                    ),
                    items: _monedas
                        .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _monedaSeleccionada = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _categoriaSeleccionada,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: ExpenseCategory.values
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(
                        c.name[0].toUpperCase() + c.name.substring(1),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _categoriaSeleccionada = value);
                }
              },
            ),
            const SizedBox(height: 16),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha'),
              subtitle: Text('${_fecha.day}/${_fecha.month}/${_fecha.year}'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onTap: _seleccionarFecha,
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _guardarGasto,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Guardar gasto', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
