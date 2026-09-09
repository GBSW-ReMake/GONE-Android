import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/core/network/dio_provider.dart';

import '../../../core/network/token_storage.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(dioProvider),
    ref.read(tokenStorageProvider),
  );
});