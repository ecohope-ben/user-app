import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RedemptionComingSoon extends StatelessWidget {
  const RedemptionComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    // 定義常量尺寸
    const double padding = 20.0;
    const double avatarRadius = 45.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none, // 允許子組件超出邊界
        alignment: Alignment.topCenter,
        children: [
          // 1. 底部白色卡片
          Container(
            margin: const EdgeInsets.only(top: avatarRadius), // 為頂部圖標留出空間
            padding: const EdgeInsets.fromLTRB(padding, padding + avatarRadius / 2 + 50, padding, padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.zero,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 根據內容自動調整高度
              children: [
                const SizedBox(height: 10),

                // 標題
                Text(
                  tr("more_exciting_rewards"),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 16),
                FittedBox(child: Text(tr("coming_soon"), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(text: tr("we_are_going_to_launch")),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),

          // 2. 頂部圓形圖標 (使用 Positioned 放在 Stack 最上層)
          Positioned(
            top: -20,
            child: Container(
              width: avatarRadius * 3,
              height: avatarRadius * 3,
              decoration: BoxDecoration(
                  color: const Color(0xFF1F2125), // 圖標背景色 (深灰近黑)
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.cyanAccent, // 青色邊框效果 (如果需要細邊框)
                    width: 1, // 這裡模擬外圈發光或邊框
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
              ),
              child: Center(
                // 這裡使用內建 Icon，如果你有圖片資源可以使用 Image.asset
                  child: Image.asset("assets/icon/gift.png", scale: 2)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

