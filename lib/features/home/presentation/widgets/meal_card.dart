import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/features/home/application/home_meal_provider.dart';
import 'package:gone/features/home/domain/meal.dart';
import 'package:gone/features/home/presentation/widgets/card_title.dart';

import '../../../../core/design_system/gone_theme.dart';

enum MealType {
  breakfast,
  lunch,
  dinner;

  static MealType? fromLabel(String label) {
    switch (label) {
      case '조식':
        return MealType.breakfast;
      case '중식':
        return MealType.lunch;
      case '석식':
        return MealType.dinner;
      default:
        return null;
    }
  }
}

const _mealTimes = {
  MealType.breakfast: (7 * 60 + 30, 8 * 60 + 0),
  MealType.lunch: (12 * 60 + 30, 13 * 60 + 40),
  MealType.dinner: (18 * 60 + 10, 19 * 60 + 10),
};

String _mealTimeLabel(MealType mealType) {
  final (start, end) = _mealTimes[mealType]!;
  return '${_formatMinutes(start)}–${_formatMinutes(end)}';
}

String _formatMinutes(int minutes) {
  final hour = (minutes ~/ 60).toString().padLeft(2, '0');
  final minute = (minutes % 60).toString().padLeft(2, '0');
  return '$hour:$minute';
}

class MealCard extends ConsumerStatefulWidget {
  const MealCard({super.key});

  @override
  ConsumerState<MealCard> createState() => _MealCardState();
}

class _MealCardState extends ConsumerState<MealCard> {
  late final PageController _mealController = _createMealController();

  int get _mealPage =>
      _mealController.hasClients ? _mealController.page?.round() ?? 0 : 0;

  PageController _createMealController() {
    final now = DateTime.now();
    final minutesNow = now.hour * 60 + now.minute;

    for (var mealType in MealType.values) {
      final (start, end) = _mealTimes[mealType]!;
      if (minutesNow < end) return PageController(initialPage: mealType.index);
    }
    return PageController(initialPage: _mealTimes.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final mealAsync = ref.watch(homeMealProvider);

    return Column(
      children: [
        CardTitle(
          icon: 'section-meal.png',
          label: '오늘 급식',
          action: Text(
            '${_mealPage + 1}/3',
            style: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: GoneColors.textSecondary),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: mealAsync.when(
            error: (error, stackTrace) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const Center(child: Text('시간표를 불러오지 못했습니다.')),
            ),
            loading: () =>
                const CircularProgressIndicator(color: GoneColors.primary),
            data: (mealData) => SizedBox(
              height: 217,
              child: PageView.builder(
                controller: _mealController,
                itemCount: mealData.length,
                onPageChanged: (value) => setState(() {}),
                itemBuilder: (context, index) =>
                    _MealCardItem(meal: mealData[index]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MealCardItem extends StatelessWidget {
  const _MealCardItem({required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '오늘의 급식',
                style: TextTheme.of(
                  context,
                ).bodySmall?.copyWith(color: GoneColors.textSecondary),
              ),
              const Spacer(),
              Text(
                _mealTimeLabel(MealType.fromLabel(meal.mealType)!),
                style: TextTheme.of(
                  context,
                ).bodySmall?.copyWith(color: GoneColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            meal.mealType,
            style: TextTheme.of(context).titleLarge?.copyWith(
              color: GoneColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Wrap(
              runSpacing: 30,
              direction: Axis.vertical,
              children: [
                for (var dish in meal.dishes)
                  SizedBox(
                    width: 100,
                    child: Text(
                      dish,
                      style: TextTheme.of(
                        context,
                      ).bodyMedium?.copyWith(color: GoneColors.textPrimary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            meal.calorie,
            style: TextTheme.of(
              context,
            ).bodyMedium?.copyWith(color: GoneColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
