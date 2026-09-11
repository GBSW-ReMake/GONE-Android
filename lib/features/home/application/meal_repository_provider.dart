import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/core/network/dio_provider.dart';
import 'package:gone/features/home/data/meal_repository.dart';

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(
    ref.read(dioProvider),
  );
});
