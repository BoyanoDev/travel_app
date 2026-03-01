class Trip {
  final String id;
  final String nombre;
  final String destino;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String? descripcion;

  Trip({
    required this.id,
    required this.nombre,
    required this.destino,
    required this.fechaInicio,
    required this.fechaFin,
    this.descripcion,
  });

  // Duración calculada automáticamente
  int get duracionDias => fechaFin.difference(fechaInicio).inDays;

  // Útil para saber si el viaje es futuro, presente o pasado
  bool get esFuturo => fechaInicio.isAfter(DateTime.now());
  bool get esPasado => fechaFin.isBefore(DateTime.now());
  bool get esActual => !esFuturo && !esPasado;

  // Convierte JSON de Supabase en objeto Trip
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      nombre: json['nombre'],
      destino: json['destino'],
      fechaInicio: DateTime.parse(json['fecha_inicio']),
      fechaFin: DateTime.parse(json['fecha_fin']),
      descripcion: json['descripcion'],
    );
  }

  // Convierte objeto Trip en JSON para enviar a Supabase
  Map<String, dynamic> toJson(String userId) {
    return {
      'user_id': userId,
      'nombre': nombre,
      'destino': destino,
      'fecha_inicio': fechaInicio.toIso8601String().substring(0, 10),
      'fecha_fin': fechaFin.toIso8601String().substring(0, 10),
      'descripcion': descripcion,
    };
  }
}
