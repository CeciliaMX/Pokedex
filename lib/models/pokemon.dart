class Pokemon{
  final int? id;
  final String? name;
  final String? description;
  final String url;
  final List<Type>? types; 
  final List<Ability>? abilities;
  final int? height;
  final int? weight;
  final int? base_experience;


  Pokemon({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    this.types,
    this.abilities,
    this.height,
    this.weight,
    this.base_experience
  });

  factory Pokemon.fromJson(Map<String, dynamic> json){
    final url = json['url'];
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final id = int.parse(segments[segments.length - 2]); 

    return Pokemon(
       id: id,
      name: json['name'],
      description: json[''],
      url: json['url'] );
  }


 factory Pokemon.fromDetailJson(Map<String, dynamic> json) {
  var typeList = json['types'] as List;
  List<Type> types = typeList.length != 0 ? typeList.map((type) => Type.fromJson(type)).toList() : [];

  var abilityList = json['abilities'] as List;
  List<Ability> abilities = abilityList.length != 0 ? abilityList.map((ability) => Ability.fromJson(ability)).toList() : []; 


  return Pokemon(
    name: json['name'],
    description: '', 
    url: "",
    id: json['id'],
    types: types,
    abilities: abilities,
    height: json['height'],
    weight: json['weight'],
    base_experience: json['base_experience']
  );
 }
  


  String get imageUrl {
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";
  }
  
}

class Type {
  final String name;

  Type({required this.name});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      name: json['type']['name'], 
    );
  }
}

class Ability {
  final String name;
  final bool isHidden;

  Ability({required this.name, required this.isHidden});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['ability']['name'], 
      isHidden: json['is_hidden'], 
    );
  }
}