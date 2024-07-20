import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lamis/main.dart';
import 'package:lamis/res/resources_export.dart';

// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../repos/user/user_repo.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  static void registerNotification() async {
    late final FirebaseMessaging messaging;
    await Firebase.initializeApp();
    if (Firebase.apps.isEmpty) {
      initializeFirebase();
    } else {
      messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // Parse the message received
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
          );

          showSimpleNotification(
            //todo dispose notification
            Text(notification.title!),
            autoDismiss: true,
            slideDismissDirection: DismissDirection.endToStart,
            leading: Icon(
              Icons.notifications_active,
              color: Theme.of(MyApp.context).colorScheme.lamisColor,
            ),
            subtitle: Text(notification.body!),
            background: Theme.of(MyApp.context).colorScheme.lamisColor,
            duration: const Duration(seconds: 30),
          );
        });
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
        FirebaseMessaging.instance.getToken().then((value) {
          String? token = value;
          UserRepo userRepo = UserRepo();
          // FcmTokenResponse fcmTokenResponse =
          if (kDebugMode) {
            print("i am going to send fcm : $token");
          }
          userRepo.sendFcmToken(deviceToken: token!);
        });
      } else {
        if (kDebugMode) {
          print('User declined or has not accepted permission');
        }
      }
    }
  }

  static void sendFcmToken() {
    if (Firebase.apps.isEmpty) {
      //initializeFirebase();
    } else {
      FirebaseMessaging.instance.getToken().then((value) async {
        await FirebaseMessaging.instance
            .getAPNSToken()
            // ignore: avoid_print
            .then((value) => print("my apn $value"));
        String? token = value;
        UserRepo userRepo = UserRepo();
        userRepo.sendFcmToken(deviceToken: token!);
      });
    }
  }

  static Future _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // print("Handling a background message: ${message.messageId}");
  }

  // static Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();
  //
  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //   //loginResult.accessToken.userId
  //   // Once signed in, return the UserCredential
  //   // var x = FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //   // final userData = await FacebookAuth.instance.getUserData();
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }
  //
  // static Future<GoogleSignInAccount?> signInWithGoogle(
  //     {required BuildContext context}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //
  //   if (auth.currentUser != null) {
  //     await auth.signOut();
  //   }
  //   // User? user;
  //
  //   GoogleSignIn _googleSignIn = GoogleSignIn(
  //     scopes: [
  //       'email',
  //     ],
  //   );
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await _googleSignIn.signIn();
  //
  //   if (googleSignInAccount != null) {
  //     return googleSignInAccount;
  //     // final GoogleSignInAuthentication googleSignInAuthentication =
  //     //     await googleSignInAccount.authentication;
  //     //
  //     // final AuthCredential credential = GoogleAuthProvider.credential(
  //     //   accessToken: googleSignInAuthentication.accessToken,
  //     //   idToken: googleSignInAuthentication.idToken,
  //     // );
  //     //
  //     // try {
  //     //   final UserCredential userCredential =
  //     //       await auth.signInWithCredential(credential);
  //     //
  //     //   user = userCredential.user;
  //     // } on FirebaseAuthException catch (e) {
  //     //   if (e.code == 'account-exists-with-different-credential') {
  //     //     ScaffoldMessenger.of(context).showSnackBar(
  //     //       Authentication.customSnackBar(
  //     //         content: 'The account already exists with a different credential',
  //     //       ),
  //     //     );
  //     //   } else if (e.code == 'invalid-credential') {
  //     //     ScaffoldMessenger.of(context).showSnackBar(
  //     //       Authentication.customSnackBar(
  //     //         content: 'Error occurred while accessing credentials. Try again.',
  //     //       ),
  //     //     );
  //     //   }
  //     // } catch (e) {
  //     //   ScaffoldMessenger.of(context).showSnackBar(
  //     //     Authentication.customSnackBar(
  //     //       content: 'Error occurred using Google Sign In. Try again.',
  //     //     ),
  //     //   );
  //     // }
  //   }
  //
  //   return null;
  // }

  static Future<void> signOut({required BuildContext context}) async {
    // final GoogleSignIn googleSignIn = GoogleSignIn();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signOut().then((_) {
        // googleSignIn.signOut();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // static Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
