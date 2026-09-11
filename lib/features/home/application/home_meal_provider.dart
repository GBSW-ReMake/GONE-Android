import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/features/home/application/meal_repository_provider.dart';
import 'package:gone/features/home/domain/meal.dart';

final homeMealProvider = FutureProvider<List<Meal>>((ref) {
  return ref.watch(mealRepositoryProvider).loadToday();
});
