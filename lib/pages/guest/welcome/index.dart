import 'package:flutter/material.dart';
import 'package:user_app/components/common/choose_language.dart';
import 'package:user_app/pages/guest/welcome/get_start.dart';
import 'package:user_app/pages/guest/welcome/page1.dart';
import 'package:user_app/pages/guest/welcome/page2.dart';

import '../../../constants.dart';


class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    changeLocalePopup();
    super.initState();
  }

  Future<void> changeLocalePopup() async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const ChangeLocalePopup(),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. 背景層 (可以在這裡放背景幾何圖片)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
                ),
              ),
              // 如果你有背景圖，取消下面的註解並替換圖片路徑
              // child: Image.asset('assets/background_lines.png', fit: BoxFit.cover),
            ),
          ),

          // 2. 右上角語言切換 (僅示意)
          Positioned(
            top: 50,
            right: 20,
            child: Row(
              children: const [
                Icon(Icons.language, color: Colors.white),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),

          // 3. 主要滑動內容
          PageView(
            controller: _pageController,
            // itemCount: _pages.length,
            onPageChanged: (int index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              WelcomePage1(),
              WelcomePage2(),
              GetStartPage()

            ],
            // itemBuilder: (context, index) {
            //   return OnboardingContent(
            //     data: _pages[index],
            //   );
            // },
          ),

          // 4. (Dots)
          Positioned(
            bottom: 50 + checkNavigationBarHeight(context),
            // bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3, (index) => buildDot(index),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 構建底部的小圓點
  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 8 : 8, // 圖片中似乎都是圓點，如果選中要變長條可改這裡
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.grey.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
