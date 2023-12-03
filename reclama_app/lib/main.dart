import 'package:flutter/material.dart';
import 'DashboardPage.dart';

void main() {
  
  runApp(const MainApp());
 
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Reclama App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
    ),
    home: const DashboardPage(),


  );
    

  
  }
}