import 'package:pokedex/models/pokemon.dart';

class PokemonList {
  final int count;
  final String? next;
  final String? previous;
  final List<Pokemon> results;

  PokemonList({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    return PokemonList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: List<Pokemon>.from(
        json['results'].map((item) => Pokemon.fromJson(item)),
      ),
    );
  }

 
}
