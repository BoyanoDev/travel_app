import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trip.dart';

class TripsService {
  final _client = Supabase.instance.client;

  // Obtener todos los viajes del usuario actual
  Future<List<Trip>> getTrips() async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) return [];

    final response = await _client
        .from('trips')
        .select()
        .eq('user_id', userId)
        .order('fecha_inicio', ascending: false);

    return response.map((json) => Trip.fromJson(json)).toList();
  }

  // Crear un viaje nuevo
  Future<Trip> createTrip(Trip trip) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client
        .from('trips')
        .insert(trip.toJson(userId))
        .select()
        .single();

    return Trip.fromJson(response);
  }

  // Eliminar un viaje
  Future<void> deleteTrip(String id) async {
    await _client.from('trips').delete().eq('id', id);
  }
}
