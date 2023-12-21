import 'package:finup/core/credentials.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_api.g.dart';

@riverpod
AuthAPI authAPI(_) => AuthAPI();

class AuthAPI {
  final _client = Supabase.instance.client;

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Stream<AuthState> get authState => _client.auth.onAuthStateChange;

  Future<AuthResponse> googleSignIn() async {
    const webClientId = GoogleSigninConstnts.Google_auth_webClientId;
    const iosClientId = GoogleSigninConstnts.Google_auth_iosClientId;
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;

    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  signOut() {
    return _client.auth.signOut();
  }
}
