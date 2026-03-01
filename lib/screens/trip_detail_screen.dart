import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_app/providers/trips_provider.dart';
import 'package:travel_app/screens/expenses_screen.dart';
import '../models/trip.dart';

class TripDetailScreen extends ConsumerWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trip.nombre),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.deblur_outlined),
            onPressed: () async {
              final confirmar = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Eliminar viaje'),
                  content: Text('¿Seguro que quierer eliminar? ${trip.nombre}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              if (confirmar == true) {
                ref.read(tripsProvider.notifier).removeTrip(trip.id);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(icono: Icons.location_on, texto: trip.destino),
            const SizedBox(height: 8),
            _InfoRow(
              icono: Icons.calendar_today,
              texto:
                  '${_formatFecha(trip.fechaInicio)} → ${_formatFecha(trip.fechaFin)}',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icono: Icons.access_time,
              texto: '${trip.duracionDias} días',
            ),
            if (trip.descripcion != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                trip.descripcion!,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Aquí añadiremos los módulos: Gastos, Transportes, Hospedajes
            const Text(
              'Módulos del viaje',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _ModuloButton(
              icono: Icons.euro,
              label: 'Gastos',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensesScreen(trip: trip),
                  ),
                );
              },
            ),
            _ModuloButton(
              icono: Icons.flight,
              label: 'Transportes',
              onTap: () {},
            ),
            _ModuloButton(
              icono: Icons.hotel,
              label: 'Hospedajes',
              onTap: () {},
            ),
            _ModuloButton(
              icono: Icons.photo_album,
              label: 'Diario',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _InfoRow({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icono,
          size: 18,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        const SizedBox(width: 8),
        Text(texto),
      ],
    );
  }
}

class _ModuloButton extends StatelessWidget {
  final IconData icono;
  final String label;
  final VoidCallback onTap;

  const _ModuloButton({
    required this.icono,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icono, color: Theme.of(context).colorScheme.onError),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
