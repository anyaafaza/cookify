import 'ingredient.dart';
import 'step.dart';
import 'nutrition.dart';

class Recipe {
  final String id;
  final String title;
  final String imagePath;
  final String description;
  final String fruitCategory;
  final String cookingTime;
  final String difficulty;
  final String portions;
  final double rating;
  final int reviewCount;
  final List<Ingredient> ingredients;
  final List<Step> steps;
  final Nutrition? nutrition;

  const Recipe({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.description,
    required this.fruitCategory,
    required this.cookingTime,
    required this.difficulty,
    required this.portions,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.ingredients = const [],
    this.steps = const [],
    this.nutrition,
  });
}
