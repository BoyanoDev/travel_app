import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip.dart';
import '../providers/trips_provider.dart';

class AddTripScreen extends ConsumerStatefulWidget {
  const AddTripScreen({super.key});

  @override
  ConsumerState<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends ConsumerState<AddTripScreen> {
  // Controladores — conectan los campos del formulario con el código
  final _nombreController = TextEditingController();
  final _destinoController = TextEditingController();
  final _descripcionController = TextEditingController();

  // Fechas seleccionadas
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  // Clave del formulario — permite validar todos los campos a la vez
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Siempre liberar los controladores al destruir el widget
    _nombreController.dispose();
    _destinoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  // Abre el selector de fecha del sistema
  Future<void> _seleccionarFecha(bool esInicio) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (fecha != null) {
      setState(() {
        if (esInicio) {
          _fechaInicio = fecha;
        } else {
          _fechaFin = fecha;
        }
      });
    }
  }

  void _guardarViaje() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona las fechas del viaje')),
      );
      return;
    }

    final nuevoViaje = Trip(
      id: '', // Supabase genera el id real
      nombre: _nombreController.text.trim(),
      destino: _destinoController.text.trim(),
      fechaInicio: _fechaInicio!,
      fechaFin: _fechaFin!,
      descripcion: _descripcionController.text.trim().isEmpty
          ? null
          : _descripcionController.text.trim(),
    );

    await ref.read(tripsProvider.notifier).addTrip(nuevoViaje);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Viaje'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Campo nombre
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del viaje',
                hintText: 'Ej: Japón 2025',
                prefixIcon: Icon(Icons.luggage),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campo destino
            TextFormField(
              controller: _destinoController,
              decoration: const InputDecoration(
                labelText: 'Destino',
                hintText: 'Ej: Tokyo',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El destino es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Selector fecha inicio
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha de inicio'),
              subtitle: Text(
                _fechaInicio == null
                    ? 'Seleccionar fecha'
                    : '${_fechaInicio!.day}/${_fechaInicio!.month}/${_fechaInicio!.year}',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onTap: () => _seleccionarFecha(true),
            ),
            const SizedBox(height: 16),

            // Selector fecha fin
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Fecha de fin'),
              subtitle: Text(
                _fechaFin == null
                    ? 'Seleccionar fecha'
                    : '${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onTap: () => _seleccionarFecha(false),
            ),
            const SizedBox(height: 16),

            // Campo descripción opcional
            TextFormField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                hintText: 'Notas sobre el viaje...',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Botón guardar
            ElevatedButton(
              onPressed: _guardarViaje,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Guardar viaje',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
