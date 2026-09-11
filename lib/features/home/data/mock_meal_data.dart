import 'package:gone/features/home/domain/meal.dart';

final mockMealData = [
  Meal(
    mealType: '조식',
    dishes: ['흰쌀밥', '소고기무국', '계란찜', '김치', '딸기우유', '요구르트'],
    calorie: '620 kcal',
  ),
  Meal(
    mealType: '중식',
    dishes: [
      '현미밥',
      '쇠고기미역국 (5.6.16)',
      '돼지갈비찜 (5.6.10.13)',
      '깻잎양념무침',
      '쌀배추무생채(해고) (5.6.13)',
      '잡채 (5.6.13.16.18)',
      '배추김치 (9)',
      '미숫가루수박화채 (2.5.13)',
    ],
    calorie: '785 kcal',
  ),
  Meal(
    mealType: '석식',
    dishes: ['잡곡밥', '된장국', '닭갈비', '콩나물무침', '배추김치', '요구르트'],
    calorie: '720 kcal',
  ),
];