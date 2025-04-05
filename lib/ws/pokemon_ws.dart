import 'package:dio/dio.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/models/pokemon_list.dart';
import '../config/dio.dart';

class PokemonWS {
  final Dio _dio = DioClient().dio;

  Future<PokemonList> getPokemonList({int offset = 0, int limit = 20}) async {
    try {
      final response = await _dio.get(
        'pokemon',
        queryParameters: {
          'offset': offset,
          'limit': limit,
        },
      );

      return PokemonList.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching Pokémon: $e');
    }
  }

  Future<Pokemon> getPokemonByNameOrId(String query) async {
    try {
      final response = await _dio.get('pokemon/$query');
      return Pokemon.fromDetailJson(response.data);
    } catch (e) {
      throw Exception('Pokémon not found: $e');
    }
  }

    Future<Pokemon> getPokemonById(int id) async {
    try {
      final response = await _dio.get('pokemon/$id');  
      return Pokemon.fromDetailJson(response.data);
    } catch (e) {
      throw Exception('Error fetching Pokémon details: $e');
    }
  }


}
