import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_app/screens/auth_screen.dart';
import 'screens/trips_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://equsgkdywlovnoighqxq.supabase.co',
    anonKey: 'sb_publishable_4xe3zrD9B-9xeju5Gw6yAw_1uVncOdp',
  );

  runApp(const ProviderScope(child: TravelApp()));
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: session != null ? const TripsScreen() : const AuthScreen(),
    );
  }
}
