import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moohub_mobile/app/app_state.dart';
import 'package:moohub_mobile/auth/login.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final appState = Get.put(AppState());

  late AnimationController controller;
  double _progress = 1.0;

  bool _counterStopped = false;

  @override
  void initState() {
    super.initState();

    SizerUtil.deviceType == DeviceType.mobile
        ? debugPrint('Device type is Mobile!')
        : debugPrint('Device type is Tablet!');

    //* Timer configuration
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    controller.addListener(() async {
      if (controller.isAnimating) {
        setState(() {
          _progress = controller.value;

          if (controller.value == 0.00) _counterStopped = true;

          // debugPrint('Counter: ${controller.value}');

          if (controller.value.toStringAsFixed(2) == '0.00') {
            Timer(const Duration(milliseconds: 500), () {
              Get.offAll(
                () => const Login(),
                duration: const Duration(milliseconds: 400),
                transition: Transition.fadeIn,
              );
            });
          }
        });
      } else {
        setState(() {
          _progress = 1.0;
        });
      }
    });

    //* Start timer
    controller.reverse(
      from: controller.value == 0 ? 1.0 : controller.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0x80c4161a),
            ),
          ),
          Container(
            color: Colors.blue.shade200,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/moohub.png'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
