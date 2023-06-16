// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:moohub_mobile/app/app_state.dart';
import 'package:moohub_mobile/app/constants.dart';
import 'package:moohub_mobile/app/methods.dart';
import 'package:moohub_mobile/auth/signup.dart';
import 'package:moohub_mobile/model/auth_model.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final appState = Get.put(AppState(), permanent: true);

  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode? _emailFocusNode;
  FocusNode? _passwordFocusNode;

  bool _showSpinnar = false;

  @override
  void initState() {
    super.initState();

    appState.isSignUpScreen.value = false;

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _emailFocusNode!.dispose();
    _passwordFocusNode!.dispose();

    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      appState.hideOrShowPassword.value = !appState.hideOrShowPassword.value;
    });
  }

  bool _isValid() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _login() {
    setState(() => _showSpinnar = true);

    signIn(LoginRequestModel(
      email: _emailController.text,
      password: _passwordController.text,
    )).then((value) async {
      // debugPrint('${value['body']['data']}');

      showFullScreenDialog(context: context, widget: _succesWidget());
      setState(() => _showSpinnar = false);
    }).catchError((err) {
      debugPrint('$err');

      showSnackbar(
        title: 'Login error...',
        message: '$err',
        tittleColor: Colors.black,
        snackDuration: const Duration(seconds: 5),
      );
      setState(() => _showSpinnar = false);
    });
  }

  Widget _succesWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Text(
          textAlign: TextAlign.center,
          "Welcome to Moohub!\nLogged in successfuly.",
          style: TextStyle(fontSize: 12.sp),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60.sp),
                Image.asset('assets/moohub.png', width: 40.w),
                Container(
                  margin: EdgeInsets.all(10.sp),
                  child: Column(
                    children: [
                      SizedBox(height: 1.h),
                      _activityText(),
                      SizedBox(height: 2.h),
                      _emailField(),
                      _passwordField(),
                      SizedBox(height: 5.h),
                      _loginButton(),
                      SizedBox(height: 5.h),
                      _alternateLogin(),
                      SizedBox(height: 5.h),
                      _signupText(),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _spinnar() {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: const Column(
        children: [
          SizedBox(height: 6),
          SpinKitThreeBounce(
            color: Colors.white,
            size: 17.5,
          ),
        ],
      ),
    );
  }

  Widget _activityText() {
    return Container(
      margin: EdgeInsets.only(top: 10.sp, left: 20.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Login to your Account',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _emailField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5.sp,
            offset: const Offset(1, 1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: _emailController,
              onTap: () => _emailFocusNode!.requestFocus(),
              onEditingComplete: () {
                _emailFocusNode!.unfocus();
                if (_emailController.text != '') _isValid();
              },
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              decoration: InputDecoration(
                counterStyle: const TextStyle(color: kPrimaryColor),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0.3.w,
                  ),
                ),
                labelStyle: const TextStyle(color: Colors.grey),
                errorStyle: const TextStyle(color: Colors.red),
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.1.w,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0.1.w,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.deepOrange,
                    width: 0.1.w,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Email is required!";
                }

                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)
                    ? null
                    : "Invalid email";
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5.sp,
            offset: const Offset(1, 1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormField(
              controller: _passwordController,
              onTap: () => _passwordFocusNode!.requestFocus(),
              onEditingComplete: () {
                _passwordFocusNode!.unfocus();
                if (_passwordController.text != '') _isValid();
              },
              focusNode: _passwordFocusNode,
              keyboardType: TextInputType.visiblePassword,
              obscureText: appState.hideOrShowPassword.value,
              textInputAction: TextInputAction.done,
              maxLines: 1,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: _toggleVisibility,
                  child: Icon(
                    appState.hideOrShowPassword.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 25.0,
                    color: Colors.grey,
                  ),
                ),
                counterStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 0.3.w,
                  ),
                ),
                labelStyle: const TextStyle(color: Colors.grey),
                errorStyle: const TextStyle(color: Colors.red),
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.1.w,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.1.w,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.sp)),
                  borderSide: BorderSide(
                    color: Colors.deepOrange,
                    width: 0.2.w,
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter your password!";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Padding(
      padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
      child: InkWell(
        onTap: () {
          if (_showSpinnar) {
            toastAlert(
                bgColor: Colors.black,
                message: 'Already clicked! Processing...',
                msgColor: Colors.white,
                gravity: ToastGravity.CENTER);

            return;
          }

          if (!_isValid()) {
            return;
          }

          //* Login API
          _login();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue.shade700,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 5.sp,
                offset: const Offset(1, 1),
              ),
            ],
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.all(Radius.circular(10.sp)),
          ),
          width: 85.w,
          height: 7.h,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: _showSpinnar
                ? _spinnar()
                : Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: const Text(
                      'Sign In',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _alternateLogin() {
    return Padding(
      padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
      child: Column(
        children: [
          const Text('-Or Sign in with'),
          SizedBox(height: 20.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => signInWithGoogle(context: context).then((value) {
                  debugPrint("$value");
                  showFullScreenDialog(
                      context: context, widget: _succesWidget());
                }),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 5.sp,
                        offset: const Offset(1, 1),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                  ),
                  width: 40.w,
                  height: 7.h,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Image.asset('assets/google.png'),
                  ),
                ),
              ),
              InkWell(
                onTap: () => signInWithFacebook().then((value) {
                  debugPrint("$value");
                  showFullScreenDialog(
                      context: context, widget: _succesWidget());
                }),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 5.sp,
                        offset: const Offset(1, 1),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                  ),
                  width: 40.w,
                  height: 7.h,
                  child: Padding(
                    padding: EdgeInsets.all(3.sp),
                    child: Image.asset('assets/facebook.png'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signupText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Dont\'t have an account?',
          style: TextStyle(color: Colors.grey, fontSize: 16.0),
        ),
        TextButton(
          onPressed: () {
            Get.to(
              () => const Signup(),
              duration: const Duration(milliseconds: 400),
              transition: Transition.fadeIn,
            );
          },
          child: const Text(
            'Signup!',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
