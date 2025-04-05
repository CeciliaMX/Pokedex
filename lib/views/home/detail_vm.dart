
import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/ws/pokemon_ws.dart';

class DetailViewModel extends ChangeNotifier {
  final PokemonWS _pokemonService = PokemonWS();

  Pokemon? _pokemon;
  bool _isLoading = false;

  
  Pokemon? get pokemon => _pokemon;
  bool get isLoading => _isLoading;

Future<void> loadPokemonDetails(int id_pokemon) async {
    try {
      final pokemonDetails = await PokemonWS().getPokemonById(id_pokemon);
      
        _pokemon = pokemonDetails;
        _isLoading = false;
    } catch (e) {
      
        _isLoading = false;
      // Mostrar error si es necesario
      print('Error fetching details: $e');
    }
    notifyListeners();
  }
}