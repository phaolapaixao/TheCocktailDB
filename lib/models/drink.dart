/// Modelo que representa um drink da API TheCocktailDB
class Drink {
  final String id;
  final String name;
  final String? category;
  final String? alcoholic;
  final String? glass;
  final String? instructions;
  final String? thumbnail;
  final List<Ingredient> ingredients;

  Drink({
    required this.id,
    required this.name,
    this.category,
    this.alcoholic,
    this.glass,
    this.instructions,
    this.thumbnail,
    required this.ingredients,
  });

  /// Factory para criar um Drink a partir do JSON da API
  factory Drink.fromJson(Map<String, dynamic> json) {
    // Extrair ingredientes e medidas
    List<Ingredient> ingredients = [];
    for (int i = 1; i <= 15; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(Ingredient(name: ingredient, measure: measure?.trim()));
      }
    }

    return Drink(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? 'Unknown',
      category: json['strCategory'],
      alcoholic: json['strAlcoholic'],
      glass: json['strGlass'],
      instructions: json['strInstructions'],
      thumbnail: json['strDrinkThumb'],
      ingredients: ingredients,
    );
  }
}

/// Modelo que representa um ingrediente com sua medida
class Ingredient {
  final String name;
  final String? measure;

  Ingredient({required this.name, this.measure});

  /// Retorna uma string formatada do ingrediente
  String get formatted {
    if (measure != null && measure!.isNotEmpty) {
      return '$measure $name';
    }
    return name;
  }
}
