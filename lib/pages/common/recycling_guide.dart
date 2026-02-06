import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecyclingGuidePage extends StatelessWidget {
  const RecyclingGuidePage({super.key});

  // 定義主題顏色
  final Color primaryPurple = const Color(0xFF4A248E);
  final Color textGrey = const Color(0xFF4A4A4A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '回收指南',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 主標題
            Text(
              '回收膠樽 DOs & DON\'Ts',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryPurple,
              ),
            ),
            const SizedBox(height: 16),
            // 描述文字
            Text(
              '每天有大量膠樽被棄置，若處理不當，不僅浪費資源，還會污染環境。以下是回收膠樽的 DOs & DON\'Ts，讓您的回收更有效。',
              style: TextStyle(fontSize: 16, color: textGrey, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 20),

            // DOs 部分
            _buildSectionTitle('DOs'),
            const SizedBox(height: 10),
            const Text('選擇可回收類型：', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 25,
              childAspectRatio: 0.75,
              children: [
                _buildGridItem('assets/icon/recycle_guide/Dos1.png', '首階段只回收\nPET (1號) 膠樽'),
                _buildGridItem('assets/icon/recycle_guide/Dos2.png', '清洗乾淨'),
                _buildGridItem('assets/icon/recycle_guide/Dos3.png', '不用移除瓶蓋及\n標籤'),
                _buildGridItem('assets/icon/recycle_guide/Dos4.png', '放入專用回收袋\n並封好'),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 20),

            // DON'Ts 部分
            _buildSectionTitle('DON\'Ts'),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 30,
              crossAxisSpacing: 20,
              childAspectRatio: 0.75,
              children: [
                _buildGridItem('assets/icon/recycle_guide/Dont1.png', '不要留有殘留物'),
                _buildGridItem('assets/icon/recycle_guide/Dont2.png', '不要放入其他\n類型的塑膠'),
                _buildGridItem('assets/icon/recycle_guide/Dont3.png', '不要混入其他垃圾'),
                _buildGridItem('assets/icon/recycle_guide/Dont4.png', '不要過度壓碎'),
              ],
            ),

            const SizedBox(height: 40),
            // 底部結語
            Text(
              '遵循這些 DOs & DON\'Ts，您的膠樽就能順利升級再造，轉為新產品！',
              style: TextStyle(fontSize: 16, color: textGrey, height: 1.5),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 小標題組件
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: primaryPurple,
      ),
    );
  }

  // 網格項目組件
  Widget _buildGridItem(String imagePath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(imagePath),
        // Container(
        //   height: 100,
        //   width: 100,
        //   decoration: BoxDecoration(
        //     color: Colors.grey[50],
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Icon(icon, size: 60, color: Colors.black87),
        // ),
        const SizedBox(height: 12),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}