import 'package:flutter/material.dart';
import 'package:pokedex/views/home/home.dart';
import 'package:pokedex/views/home/home_vm.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()..fetchStartPokemon()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pokedex',
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomeView(),
    );
  }
}
