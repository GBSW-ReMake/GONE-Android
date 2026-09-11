import 'package:dio/dio.dart';
import 'package:gone/features/home/data/mock_meal_data.dart';
import 'package:gone/features/home/domain/meal.dart';

class MealRepository {
  MealRepository(this._dio);

  final Dio _dio;

  Future<List<Meal>> loadToday() async {
    return mockMealData;
  }
}