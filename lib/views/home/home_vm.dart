import 'package:flutter/material.dart';
import '../../models/pokemon.dart';
import '../../ws/pokemon_ws.dart';

class HomeViewModel extends ChangeNotifier {
  final PokemonWS _pokemonService = PokemonWS();

  List<Pokemon> _all_pokemons = [];
  List<Pokemon> _pokemonList= [];  
  bool _isLoading = false;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;

  bool _isFetchingMore = false;
  int _offset = 0;
  final int _limit = 20;

  Future<void> fetchStartPokemon() async {
    _isLoading = true;
    notifyListeners();

   /* try {
      final response = await _pokemonService.getPokemonList();
      _all_pokemons = response.results;
      _pokemonList = List.from(_all_pokemons);
    } catch (e) {
      // puedes agregar un mensaje de error
    }*/

     try {
      final results = await _pokemonService.getPokemonList(offset: _offset, limit: _limit);
      _pokemonList = results.results;
      _all_pokemons = _pokemonList;
      _offset += _limit;
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

   Future<void> fetchMorePokemon() async {
    if (_isFetchingMore) return;

    _isFetchingMore = true;
    notifyListeners();

    try {
      final moreResults = await _pokemonService.getPokemonList(offset: _offset, limit: _limit);
      _pokemonList.addAll(moreResults.results);
      _offset += _limit;
    } catch (_) {}

    _isFetchingMore = false;
    notifyListeners();
  }

  void sortPokemons({required bool byName}) {
   if (byName) {
      _pokemonList.sort((a, b) => a.name!.compareTo(b.name!));
    } else {
      _pokemonList = List.from(_all_pokemons); 
      _pokemonList.sort((a, b) => a.id!.compareTo(b.id!));
    }
  
    notifyListeners();
  }

   void filterPokemons(String query) {
    if (query.isEmpty) {
      _pokemonList= List.from(_all_pokemons);
    } else {
      _pokemonList = _all_pokemons
          .where((p) => p.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<void> searchPokemonOnline(String query) async {
  _isLoading = true;
  notifyListeners();

  try {
    _pokemonList = [];
    notifyListeners();

    final pokemon = await _pokemonService.getPokemonByNameOrId(query.toLowerCase());

    _pokemonList = [pokemon];
  } catch (e) {
    _pokemonList = [];
  }

  _isLoading = false;
  notifyListeners();
}


}
