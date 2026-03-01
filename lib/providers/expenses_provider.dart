import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/expense.dart';
import '../services/expenses_services.dart';

class ExpensesNotifier extends StateNotifier<AsyncValue<List<Expense>>> {
  final ExpensesService _service = ExpensesService();
  final String tripId;

  ExpensesNotifier(this.tripId) : super(const AsyncValue.loading()) {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    try {
      state = const AsyncValue.loading();
      final expenses = await _service.getExpenses(tripId);
      state = AsyncValue.data(expenses);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final newExpense = await _service.createExpense(expense);
      state = AsyncValue.data([...state.value ?? [], newExpense]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeExpense(String id) async {
    try {
      state = AsyncValue.data(state.value!.where((e) => e.id != id).toList());
      await _service.deleteExpense(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final expensesProvider =
    StateNotifierProvider.family<
      ExpensesNotifier,
      AsyncValue<List<Expense>>,
      String
    >((ref, tripId) => ExpensesNotifier(tripId));
