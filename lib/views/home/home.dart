import 'package:flutter/material.dart';
import 'package:pokedex/utils/colors_app.dart';
import 'package:pokedex/views/home/detail_vm.dart';
import 'package:pokedex/views/home/pokemon_detail_view.dart';
import 'package:provider/provider.dart';
import 'home_vm.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
    late ScrollController _scrollController;
   int _selectedOption = 1;

   
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<HomeViewModel>();
    //viewModel.fetchInitialPokemon();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        viewModel.fetchMorePokemon();
      }
    });
  }

   @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _selectedOption = value;
    });
  }


  void _showAlertDialog(BuildContext context,  HomeViewModel viewModel) {
        int tempSelectedOption = _selectedOption;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialog) {
          return AlertDialog(
            title: const Text('Sort by'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Name'),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: tempSelectedOption,
                    onChanged: (int? value) {
                      setStateDialog(() => tempSelectedOption = value!);
                      setState(() => _selectedOption = value!);
                      viewModel.sortPokemons(byName: true);
                      Navigator.pop(context);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Number'),
                  leading: Radio<int>(
                    value: 2,
                    groupValue: tempSelectedOption,
                    onChanged: (int? value) {
                     setStateDialog(() => tempSelectedOption = value!);
                      setState(() => _selectedOption = value!);
                      viewModel.sortPokemons(byName: false);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex', style: TextStyle(  fontWeight: FontWeight.bold, ),), 
                      backgroundColor: ColorsApp.appbar, foregroundColor: ColorsApp.textWhite, ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(5),
              child: Column(children: [
                Row(children: [
                    Expanded(child:  TextField(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                     onSubmitted: (query) {
                        if (query.trim().isNotEmpty) {
                         if (query.length < 3) {
                            viewModel.filterPokemons(query); 
                          } else {
                            viewModel.searchPokemonOnline(query); 
                          }
                        }
                      },
                    ),
                    ),
                    SizedBox(width: 5,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), 
                          side: BorderSide(color: Colors.red, width: 2), 
                        ),
                        padding: EdgeInsets.all(8), 
                      ),
                      onPressed: ()  => _showAlertDialog(context, viewModel)
                      ,
                      child: Image.asset('assets/images/ic_config.png',
                                width: 50,
                                height: 40,
                                fit: BoxFit.fill,),
                    ),
              ],),
              Expanded(child: 
                GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, 
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.7,
              ),
              itemCount: viewModel.pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = viewModel.pokemonList[index];
                return GestureDetector(onTap: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => DetailViewModel(),
                              child: PokemonDetailView(pokemon_id: pokemon.id!),
                            ),
                          ),
                        );

                      },
                      child: 
                Card(elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  pokemon.imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                pokemon.name!.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                  
                )
                );
              },
            ),
              )
            ],)
          )
    );
  }
}
