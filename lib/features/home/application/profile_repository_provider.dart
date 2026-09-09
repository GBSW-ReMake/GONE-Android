import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_profile_card_data.dart';
import '../domain/profile_card_data.dart';

final profileRepositoryProvider = FutureProvider<ProfileCardData>((ref) async {
  return mockProfileCardData;
});