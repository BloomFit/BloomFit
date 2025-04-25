import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_app/app/constants/colors.dart';

import '../controllers/spalsh_controller.dart';

class SpalshView extends GetView<SpalshController> {
  const SpalshView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColorsDark.primary,
      child:Center(
        child: Image.asset(
          'assets/logo/logo.png',
        width: MediaQuery.of(context).size.width/2,
        height: MediaQuery.of(context).size.width/4,
        ),
      )
      ),
    );
  }
}
