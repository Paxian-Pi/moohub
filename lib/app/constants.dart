import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const isLoggedIn = 'isLoggedIn';
const isFirstTime = 'isFirstTime';
const isSignupCompleted = 'isSignupCompleted';
const isVerificationCompleted = 'isVerificationCompleted';

const stopTimer = 'stopTimer';

const userId = 'userId';
const email = 'email';

const baseUrl = 'https://api.backend.gentro.io/mobile/';

const kPrimaryColor = Color(0xFF6191D8);
const kAccentColor = Color.fromARGB(255, 200, 201, 200);
const kTextShadowColor = Color(0x4D000000);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF67E8B9), Color(0xFF3EB489)],
);

const Icon voltage = Icon(Icons.electric_bolt, color: Colors.white);

final kTextShadow = [
  Shadow(offset: Offset(0, 0.1.h), blurRadius: 6.0.sp, color: kTextShadowColor),
];

final kBoxShadow = [
  BoxShadow(
    color: kPrimaryColor,
    spreadRadius: 5,
    blurRadius: 30.sp,
    offset: const Offset(0, 3),
  ),
];
