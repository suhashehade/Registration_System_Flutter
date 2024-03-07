import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:registration_app/main.dart';
import 'package:registration_app/models/user.dart';

class GoogleAuthController extends GetxController {
  GoogleSignInAccount? currentUser;
  RxBool isAuthorized = false.obs;
  RxString contactText = ''.obs;

  static final List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  final GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    serverClientId:
        '584512198614-69o4quubbmmkd0cads87jv0debdjhh98.apps.googleusercontent.com',
    scopes: scopes,
  );

  Future<void> handleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        CustomUser user = CustomUser(
            name: googleUser.displayName.toString(),
            nationalNumber: '',
            dateOfBirth: '',
            title: '',
            photo: '',
            phone: '',
            email: googleUser.email.toString());
        Map<String, dynamic> userMap = user.toMap();
        await db!.insert('users', userMap);

        Get.offNamed('/archive');
      } else {
        print('Google Sign-In cancelled.');
      }
    } catch (error) {
      print('Google Sign-In error: $error');
    }
  }

  Future<void> handleGetContact(GoogleSignInAccount user) async {
    contactText.value = 'Loading ...';
    final http.Response response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me/connections?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      contactText.value = 'People API gave a ${response.statusCode} '
          'response. Check logs for details.';

      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);

    if (namedContact != null) {
      contactText.value = 'I see you know $namedContact!';
    } else {
      contactText.value = 'No contacts to display.';
    }
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> handleAuthorizeScopes() async {
    isAuthorized.value = await googleSignIn.requestScopes(scopes);
    if (isAuthorized.value) {
      unawaited(handleGetContact(currentUser!));
    }
  }

  Future<void> handleSignOut() => googleSignIn.disconnect();

  @override
  void onInit() {
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      isAuthorized.value = account != null;
      if (kIsWeb && account != null) {
        isAuthorized.value = await googleSignIn.canAccessScopes(scopes);
      }
      if (isAuthorized.value) {
        unawaited(handleGetContact(account!));
      }
    });
    googleSignIn.signInSilently();
    super.onInit();
  }
}
