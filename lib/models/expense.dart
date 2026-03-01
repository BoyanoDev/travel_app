enum ExpenseCategory { transporte, alojamiento, comida, ocio, compras, otros }

class Expense {
  final String id;
  final String tripId;
  final String descripcion;
  final double importe;
  final String moneda;
  final ExpenseCategory categoria;
  final DateTime fecha;
  final String? nota;

  Expense({
    required this.id,
    required this.tripId,
    required this.descripcion,
    required this.importe,
    required this.moneda,
    required this.categoria,
    required this.fecha,
    this.nota,
  });

  // Convierte JSON de Supabase en objeto Trip
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      tripId: json['trip_id'],
      descripcion: json['descripcion'],
      importe: (json['importe'] as num).toDouble(),
      moneda: json['moneda'],
      categoria: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['categoria'],
      ),
      fecha: DateTime.parse(json['fecha']),
      nota: json['nota'],
    );
  }

  // Convierte objeto Trip en JSON para enviar a Supabase
  Map<String, dynamic> toJson(String userId) {
    return {
      'trip_id': tripId,
      'user_id': userId,
      'descripcion': descripcion,
      'importe': importe,
      'moneda': moneda,
      'categoria': categoria.name,
      'fecha': fecha.toIso8601String().substring(0, 10),
      'nota': nota,
    };
  }
}
