import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/models/expense.dart';

class ExpensesService {
  final _client = Supabase.instance.client;

  //Obtener Todos los gastos del viaje actual
  Future<List<Expense>> getExpenses(String tripId) async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) return [];

    final response = await _client
        .from('expenses')
        .select()
        .eq('trip_id', tripId)
        .order('fecha', ascending: false);

    return response.map((json) => Expense.fromJson(json)).toList();
  }

  //Crear un gasto nuevo
  Future<Expense> createExpense(Expense expense) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('expenses')
        .insert(expense.toJson(userId))
        .select()
        .single();
    return Expense.fromJson(response);
  }

  // Eliminar un viaje
  Future<void> deleteExpense(String id) async {
    await _client.from('expenses').delete().eq('id', id);
  }
}
