import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:registration_app/main.dart';
import 'package:registration_app/models/user.dart';

class AuthController extends GetxController {
  RxBool isChecked = false.obs;
  RxString messageError = ''.obs;
  Future<void> signInWithGoogle() async {
    messageError.value = '';
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await googleUser?.clearAuthCache();
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await prefs!.setBool('isLogin', true);

    final http.Response responseData =
        await http.get(Uri.parse(userCredential.user!.photoURL.toString()));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);

    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${DateTime.now()}.png')
        .writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    CustomUser user = CustomUser(
        name: userCredential.user!.displayName.toString(),
        nationalNumber: '',
        dateOfBirth: '',
        title: '',
        photo: file.path,
        phone: '',
        email: userCredential.user!.email.toString());
    try {
      List<Map> resLogin = await login(user.name.toLowerCase(), user.email);
      if (resLogin.isEmpty) {
        int res = await signUp('users', user);
        if (res > 0) {
          messageError.value = '';
        }
      } else {
        await handleSignOutGoogle();
      }
    } catch (e) {
      await handleSignOutGoogle();
    }
  }

  Future<void> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    await prefs!.setBool('isLogin', true);
    final http.Response responseData =
        await http.get(Uri.parse(userCredential.user!.photoURL.toString()));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);

    final dir = await getTemporaryDirectory();
    File file = await File('${dir.path}/${DateTime.now()}.png').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    CustomUser user = CustomUser(
        name: userCredential.user!.displayName.toString(),
        nationalNumber: '',
        dateOfBirth: '',
        title: '',
        photo: file.path,
        phone: '',
        email: userCredential.user!.email.toString());
    try {
      List<Map> resLogin = await login(user.name.toLowerCase(), user.email);
      if (resLogin.isEmpty) {
        int res = await signUp('users', user);
        if (res > 0) {
          messageError.value = '';
        } else {
          await handleSignOutFacebook();
        }
      }
    } catch (e) {
      await handleSignOutFacebook();
    }
  }

  Future<void> handleSignOutGoogle() async =>
      await FirebaseAuth.instance.signOut();
  Future<void> handleSignOutFacebook() async =>
      await FacebookAuth.instance.logOut();

  toggleCheck(value) {
    isChecked.value = value!;
  }

  signUp(String table, CustomUser user) async {
    try {
      List<Map> res = await login(user.name.toLowerCase(), user.email);
      if (res.isEmpty) {
        Map<String, dynamic> userMap = user.toMap();
        int response = await db!.insert(table, userMap);
        return response;
      } else {}
    } catch (e) {
      messageError.value = 'You already have an account';
    }
  }

  login(name, email) async {
    List<Map> res = await db!.login('''SELECT * FROM users WHERE 
                                name='$name' 
                                AND email='$email' ''');

    return res;
  }

  logout() async {
    if (await GoogleSignIn().isSignedIn()) {
      await handleSignOutGoogle();
      await handleSignOutFacebook();
      await GoogleSignIn().disconnect();
    }
    prefs!.clear();
    isChecked.value = false;
  }
}
