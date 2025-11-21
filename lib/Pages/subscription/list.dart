import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SubscriptionListPage extends StatelessWidget {
  const SubscriptionListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "Subscriptions",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Join a plan to start recycling",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            const Text(
              "You can cancel anytime.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // 1. Monthly Plan Card (Purple)
            const SubscriptionCard(
              themeColor: Color(0xFF9747FF), // 紫色
              lightColor: Color(0xFFE0C9FF), // 淺紫色 (用於背景圖案區)
              imagePath: "assets/widget/subscription_header_monthly.png",
              title: "Monthly Plan",
              originalPrice: "100",
              currentPrice: "0",
              features: [
                "1 welcome gift",
                "1 Free recycle bag",
                "1 time pick up",
                "Flexible pick up time and locations",
                "Live tracking with recycling progress",
                "Personalized recycling records",
              ],
            ),

            const SizedBox(height: 20),

            // 2. Yearly Plan Card (Blue)
            const SubscriptionCard(
              themeColor: Color(0xFF2D5BFF), // 藍色
              lightColor: Color(0xFFCAD5FF), // 淺藍色

              imagePath: "assets/widget/subscription_header_yearly.png",
              title: "Yearly Plan",
              originalPrice: "1300",
              currentPrice: "1000",
              features: [
                "Save up to \$300",
                "12 times pick up",
                "Flexible pick up time and locations",
                "Live tracking with recycling progress",
                "Personalized recycling records",
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final Color themeColor;
  final Color lightColor;
  final String imagePath;
  final String title;
  final String originalPrice;
  final String currentPrice;
  final List<String> features;

  const SubscriptionCard({
    super.key,
    required this.themeColor,
    required this.lightColor,
    required this.imagePath,
    required this.title,
    required this.originalPrice,
    required this.currentPrice,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: themeColor, width: 1), // 外框顏色跟隨主題
      ),
      child: Column(
        children: [

          SizedBox(
            height: 90,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(imagePath) as ImageProvider,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 左側文字資訊
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Subscription",
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              // originalPrice
                              Text(
                                "\$$originalPrice",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.white70,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // 現價
                              Text(
                                "\$$currentPrice",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                " | ",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Join now button
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        ),
                        child: const Text("Join Now"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Card Body (Features List) ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: features.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check,
                        color: themeColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// 自定義剪裁路徑，用於製作 Header 的斜角效果
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(size.width * 0.55, 0); // 上方線條畫到 65% 寬度

    path.lineTo(size.width * 0.85, size.height); // 下方線條畫到 55% 寬度 (形成斜角)
    path.lineTo(0, size.height); // 回到左下角
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}