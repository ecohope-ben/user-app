import 'package:flutter/material.dart';

import '../register/steps/create_profile.dart';

class OnboardingProfile extends StatelessWidget {
  const OnboardingProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios_new, color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
            child: CreateProfileStep()
        )
      ),
    );
  }
}
