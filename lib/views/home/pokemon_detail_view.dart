import 'package:flutter/material.dart';
import 'package:pokedex/views/home/detail_vm.dart';
import 'package:provider/provider.dart';
import '../../models/pokemon.dart';

class PokemonDetailView extends StatefulWidget {
  final int pokemon_id;

  const PokemonDetailView({super.key, required this.pokemon_id});

   @override
  _PokemonDetailViewState createState() => _PokemonDetailViewState();
}

class _PokemonDetailViewState extends State<PokemonDetailView> {
 

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<DetailViewModel>();

    viewModel.loadPokemonDetails(widget.pokemon_id);
  }

   Widget _buildStatContainer(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          title != '' ? Text(
            title,
            style: TextStyle(
              color: Colors.red.shade900,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
          : Container(),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        final viewModel = context.watch<DetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text(viewModel.pokemon?.name?.toUpperCase() ?? 'Loading...'),
        ]),
        actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Text(
            '# ${viewModel.pokemon?.id}',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    color: Colors.red.shade50, // Fondo color suave
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          viewModel.pokemon?.imageUrl != null 
                          ? Center(
                            child: Image.network(
                              viewModel.pokemon?.imageUrl ?? 'assets/images/ic_no_img.png',
                              height: 250,
                              fit: BoxFit.contain,
                            ),
                          )
                          : Container(),
                          const SizedBox(height: 20),
                          Center(child: Text('Details',
                            style: TextStyle(fontSize: 20, color: Colors.red.shade900),
                          ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                              children: [
                                // Diseño de peso y estatura en un solo renglón
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Peso
                                    _buildStatContainer('Weight', viewModel.pokemon?.weight?.toString() ?? ''),

                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.red,
                                      margin: const EdgeInsets.symmetric(horizontal: 12),
                                    ),

                                    _buildStatContainer('Height', viewModel.pokemon?.height?.toString() ?? ''),

                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: Colors.red,
                                      margin: const EdgeInsets.symmetric(horizontal: 12),
                                    ),

                                    _buildStatContainer('Experience', viewModel.pokemon?.base_experience?.toString() ?? ''),

                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Más contenido aquí...
                              ],
                          ),
                            Text('Types:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          _buildStatContainer('', viewModel.pokemon?.types?.map((type) => type.name).join(', ') ?? 'No types available'),
                          const SizedBox(height: 20),

                          Text(
                            'Abilities:',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900, fontSize: 16),
                          ),
                          const SizedBox(height: 5),
                          _buildStatContainer('', viewModel.pokemon?.abilities?.map((ability) => ability.name).join(', ') ?? 'No abilities available'),
                          
                        ],
                      ),
                    ),
                  ),
                ], /*Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    viewModel.pokemon?.imageUrl?? '',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'ID: ${viewModel.pokemon?.id ?? 'N/A'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(viewModel.pokemon?.description ?? 'No description available'),
                ],
        ),*/
      ),
    ));
  }
}
