import 'package:finup/apis/auth_api.dart';
import 'package:finup/core/routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_user.g.dart';

@riverpod
Stream<User?> authUser(AuthUserRef ref) async* {
  final authStream = ref.watch(authAPIProvider).authState;

  await for (final authState in authStream) {
    yield authState.session?.user;
  }
}
