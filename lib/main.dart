import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/bike_provider.dart';
import 'screens/home_wrapper.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final bikeProvider = BikeProvider();
  await bikeProvider.init(); 

  runApp(
    ChangeNotifierProvider.value(
      value: bikeProvider,
      child: const WrenchApp(),
    ),
  );
}

class WrenchApp extends StatelessWidget {
  const WrenchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BikeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wrench',
      themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: Colors.blueAccent,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.blueAccent,
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: const HomeWrapper(), 
    );
  }
}