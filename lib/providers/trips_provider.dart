import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip.dart';
import '../services/trips_services.dart';

class TripsNotifier extends AsyncNotifier<List<Trip>> {
  final TripsService _service = TripsService();

  @override
  Future<List<Trip>> build() async {
    return await _service.getTrips();
  }

  Future<void> addTrip(Trip trip) async {
    final newTrip = await _service.createTrip(trip);
    state = AsyncData([newTrip, ...state.value ?? []]);
  }

  Future<void> removeTrip(String id) async {
    await _service.deleteTrip(id);
    state = AsyncData(state.value!.where((t) => t.id != id).toList());
  }
}

final tripsProvider = AsyncNotifierProvider<TripsNotifier, List<Trip>>(
  TripsNotifier.new,
);
