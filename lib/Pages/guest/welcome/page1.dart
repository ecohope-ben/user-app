import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import '../../../style.dart';

class WelcomePage1 extends StatelessWidget {
  const WelcomePage1({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kBackgroundColor = Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/welcome_bg1.png') as ImageProvider,
                  fit: BoxFit.cover
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C2C2C), Color(0xFF121212)],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const Spacer(flex: 3),

                    Image.asset("assets/icon/welcome/bottle.png", width: 300),

                    const Spacer(flex: 1),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                            children: [
                              TextSpan(text: tr("welcome.page1.title1")),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Transform.rotate(
                                  angle: 0.05, // rotate
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                    decoration: BoxDecoration(
                                      color: welcomeWordsBg,
                                    ),
                                    child: Transform.rotate(
                                      angle: -0.05, // rotate
                                      child: Text(
                                        tr("welcome.page1.highlight"),
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      tr("welcome.page1.title2"),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),

                    const Spacer(flex: 2),

                    const Spacer(flex: 1),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

