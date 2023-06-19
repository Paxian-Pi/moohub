import 'package:animated_widgets/widgets/scale_animated.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moohub_mobile/app/app_state.dart';
import 'package:moohub_mobile/app/constants.dart';
import 'package:moohub_mobile/auth/login.dart';
import 'package:moohub_mobile/model/auth_model.dart';
import 'package:sizer/sizer.dart';

final appState = Get.put(AppState(), permanent: true);

final Dio _dio = Dio();

Future signIn(LoginRequestModel requestModel) async {
  // String authUrl = '${baseUrl}users/auth';
  String authUrl = 'https://quizzasports.com/api/v1/auth/login';

  try {
    _dio.options.headers['content-Type'] = 'application/json';

    final response = await _dio.post(authUrl, data: requestModel);

    return response.data;
  } on DioException catch (e) {
    // debugPrint(e.response.toString());
    return e.response.toString();
  }
}

Future signUp(SignupRequestModel requestModel) async {
  // String authUrl = '${baseUrl}users/sign-up';
  String authUrl = 'https://quizzasports.com/api/v1/auth/register';

  try {
    _dio.options.headers['content-Type'] = 'application/json';

    final response = await _dio.post(authUrl, data: requestModel);

    return response.data;
  } on DioException catch (e) {
    // debugPrint(e.response.toString());
    return e.response.toString();
  }
}

Future<UserCredential> signInWithFacebook() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance
      .login(permissions: ['public_profile', 'email']);

  if (loginResult.status == LoginStatus.success) {
    debugPrint("Successful login");
  }

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  final UserCredential userCredential =
      await auth.signInWithCredential(facebookAuthCredential);

  user = userCredential.user;
  debugPrint("$user");

  // Once signed in, return the UserCredential
  return userCredential;
}

Future<User?> signInWithGoogle({required BuildContext context}) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);

      user = userCredential.user;
      appState.isUser.value = true;
      debugPrint("$user");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
        toastAlert(
            bgColor: Colors.black,
            message: 'duplicate account: ${e.code}',
            msgColor: Colors.white,
            gravity: ToastGravity.CENTER);
      } else if (e.code == 'invalid-credential') {
        // handle the error here
        toastAlert(
            bgColor: Colors.black,
            message: e.code,
            msgColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }
    } catch (e) {
      // handle the error here
      toastAlert(
          bgColor: Colors.black,
          message: 'Something went wrong... ${e.toString()}',
          msgColor: Colors.white,
          gravity: ToastGravity.CENTER);
    }
  }

  return user;
}

Future<void> signOut({required BuildContext context}) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  try {
    if (!kIsWeb) {
      await googleSignIn.signOut();
    }
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    showSnackbar(title: "Error", message: "Error signing out...");
  }
}

Future<void> toastAlert(
    {Color? bgColor,
    Color? msgColor,
    ToastGravity? gravity,
    required String message}) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity ?? ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor ?? Colors.transparent,
    textColor: msgColor ?? Colors.black,
    fontSize: 12.sp,
  );
}

void showSnackbar({
  required String title,
  required String message,
  Color? msgColor,
  Color? tittleColor,
  Color? bgColor,
  Duration? snackDuration,
  SnackPosition? position,
}) {
  Get.snackbar('', '',
      duration: snackDuration ?? const Duration(seconds: 3),
      titleText: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: tittleColor ?? kAccentColor),
      ),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: msgColor ?? Colors.grey,
          fontSize: 16,
        ),
      ),
      backgroundColor: bgColor,
      snackPosition: position ?? SnackPosition.BOTTOM);
}

void showFullScreenDialog(
    {required BuildContext context, required Widget widget}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return GestureDetector(
        onTap: () {
          if (appState.isSignUpScreen.value) {
            Get.to(
              () => const Login(),
              duration: const Duration(milliseconds: 400),
              transition: Transition.fadeIn,
            );

            return;
          }

          Get.back();
        },
        child: Scaffold(
          backgroundColor: Colors.black45,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30.sp),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                  ),
                  child: ScaleAnimatedWidget.tween(
                    enabled: true,
                    duration: const Duration(milliseconds: 300),
                    scaleDisabled: 0.5,
                    scaleEnabled: 1,
                    child: widget,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
