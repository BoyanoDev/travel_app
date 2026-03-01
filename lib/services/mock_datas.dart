import '../models/trip.dart';

final List<Trip> mockTrips = [
  Trip(
    id: '1',
    nombre: 'Japón 2025',
    destino: 'Tokyo',
    fechaInicio: DateTime(2025, 4, 10),
    fechaFin: DateTime(2025, 4, 24),
    descripcion: 'Viaje de dos semanas explorando Tokyo, Kyoto y Osaka',
  ),
  Trip(
    id: '2',
    nombre: 'Lisboa escapada',
    destino: 'Lisboa',
    fechaInicio: DateTime(2025, 6, 5),
    fechaFin: DateTime(2025, 6, 9),
    descripcion: 'Fin de semana largo en Lisboa',
  ),
  Trip(
    id: '3',
    nombre: 'Nueva York',
    destino: 'Nueva York',
    fechaInicio: DateTime(2024, 11, 15),
    fechaFin: DateTime(2024, 11, 22),
  ),
  Trip(
    id: '4',
    nombre: 'Asturias',
    destino: 'Asturias/Giojon',
    fechaInicio: DateTime(2026, 03, 16),
    fechaFin: DateTime(2027, 03, 19),
  ),
];
