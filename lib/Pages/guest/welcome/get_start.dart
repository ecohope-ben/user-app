import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import '../../../style.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 定義顏色
    const Color kBackgroundColor = Color(0xFF1E1E1E); // 深灰背景
    const Color kAccentCyan = Color(0xFF00E5FF); // 青色/亮藍色
    const Color kTextColor = Colors.white;
    const Color kSubTextColor = Colors.white70;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          // 1. 背景圖層 (Background Pattern)
          // 如果你有幾何圖案的圖片，使用 Image.asset 放在這裡
          // 這裡我們用一個漸層或 Container 模擬深色背景
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/welcome_bg.png') as ImageProvider,
                fit: BoxFit.cover
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C2C2C), Color(0xFF121212)],
              ),
            ),
          ),

          // 為了模擬背景的幾何線條，這裡只是一個簡單的示意
          // 實際專案中請使用 Image.asset("assets/background_pattern.png")

          // 2. 主要內容 (Main Content)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  Image.asset("assets/icon/white_logo.png", width: 180),

                  const Spacer(flex: 1),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0), // 左右留白
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
                            const TextSpan(text: 'Every Pickup Creates '),
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
                                    child: const Text(
                                      'Change',
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

                  const Text(
                    "Your bottles are upcycled into new products,\ngiving plastic a second life.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Get Started 按鈕
                  Container(
                      width: double.infinity,
                      height: 40,
                      // padding: const EdgeInsets.symmetric(vertical: 0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          bottom: BorderSide(
                            color: blueTextUnderline,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          context.push("/home");
                          print("Get Started Tapped");
                        },
                        child: Text("Get Started", textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ), ),
                      ),
                    ),


                  const SizedBox(height: 24),

                  // Login 文字連結
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "Login",
                          style: const TextStyle(
                            color: Colors.blueAccent, // 藍色連結
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Login Tapped");
                            },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // 分頁指示器 (Dots)
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     _buildDot(isActive: false),
                  //     const SizedBox(width: 8),
                  //     _buildDot(isActive: false),
                  //     const SizedBox(width: 8),
                  //     _buildDot(isActive: true), // 假設這是第三頁
                  //   ],
                  // ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[700],
        shape: BoxShape.circle,
      ),
    );
  }
}

