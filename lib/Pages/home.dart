import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/routes.dart';

import '../blocs/login_cubit.dart';
import '../style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Scrollable
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopSection(),
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [

                          // 1. purple banner
                          _buildSubscriptionBanner(()=> context.push("/subscription/list")),
        
                          const SizedBox(height: 20),
        
                          // 2. Info Card
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                _buildInfoCard(
                                  title: "How it works?",
                                  description: "We provide door to door collection Upcycle Your Way to a Greener Tomorrow!",
                                  imagePath: "assets/widget/how_it_work.png",
                                  icon: Icons.change_circle_outlined,
                                ),
                                const SizedBox(height: 16),
                                _buildInfoCard(
                                  title: "Recycling Guide",
                                  description: "Dos and Don’ts we rely on you to apply the recycling guide properly!",
                                  imagePath: "assets/widget/recycle_guide.png",
                                  icon: Icons.list_alt,
                                ),
                              ],
                            ),
                          ),
        
                          const SizedBox(height: 100),
        
                        ],
                      ),
                    )
                ),
              ],
            ),
        
            // 4.
            const Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration:  BoxDecoration(
        image: DecorationImage(

          fit: BoxFit.cover,
          image: AssetImage('assets/widget/home_bg.png') as ImageProvider,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE0EBFF), Color(0xFFD6F5FF)], // 模擬淺藍漸層
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar 和 問號 Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF1A103C), // 深色圓圈
                radius: 24,
                child: Text(
                  "A",
                  style: TextStyle(color: mainPurple, fontSize: 20),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.question_mark, size: 20),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Hello User
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 24, color: Colors.black),
              children: [
                TextSpan(text: "Hello, "),
                TextSpan(
                  text: "Amy Lau",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem("00", "Pick Up"),
              _buildStatItem("No subscription", "Subscriptions"),
              _buildStatItem("00", "Total collections"),
            ],
          ),
        ],
      ),
    );
  }

  // 構建單個統計數據
  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildSubscriptionBanner(VoidCallback onTap) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6200EA), Color(0xFFB388FF)], // 紫色漸層
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            "SUBSCRIBE NOW TO EARN WELCOME GIFT",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
              children: [
                const TextSpan(text: "Join our monthly plan with "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Transform.rotate(
                    angle: -0.06, // rotate
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                      color: Colors.cyanAccent,
                      child: Transform.rotate(
                        angle: 0.06, // rotate
                        child: const Text(
                          "\$0",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const TextSpan(text: " now to earn\nfree welcome gift!"),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Subscribe 按鈕
          SizedBox(
            width: double.infinity - 300,
            child: TextButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E), // 深灰接近黑色
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text("Subscribe", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // 構建資訊卡片 (可重用)
  Widget _buildInfoCard({
    required String title,
    required String description,
    required String imagePath,
    required IconData icon,
  }) {
    return Container(
      // height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 左側圖片區 (這裡用 Container 模擬)
          Expanded(
            flex: 1,
            child: Center(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                      fit: BoxFit.cover,
                      imagePath
                  ),
                ),
              ),
          ),
          // 右側文字區
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 自定義底部導航列 Widget
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200, // 控制導航列寬度
        height: 70, // 總高度包含突出的按鈕
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 底部白色膠囊背景
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_filled, color: Colors.black),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 40), // 中間留空給大按鈕
                  IconButton(
                    icon: const Icon(Icons.star_border, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // 中間突出的大圓按鈕
            Positioned(
              top: 0,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black, // 黑色背景
                      shape: BoxShape.circle,
                      // border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                  ),
                  child: Image.asset("assets/icon/nav_main.png", scale: 3)
              ),
            ),
          ],
        ),
      ),
    );
  }
}