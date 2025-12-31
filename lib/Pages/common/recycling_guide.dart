import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecyclingGuidePage extends StatelessWidget {
  const RecyclingGuidePage({super.key});

  final Color checkGreen = const Color(0xFF4CAF50); // tick
  final Color textDark = const Color(0xFF2B4C55); // word

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF376752),
                Color(0xFF294F55),
                Color(0xFF294F55),
                Color(0xFF294F55),
              ],
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
          onPressed: () => context.pop(context),
        ),
        title: Text(
          tr("recycle_guide.title"),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. "How?" Title
              Text(
                tr("recycle_guide.how"),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // 2. Process Title "Empty -> Clean -> Squash"
              Row(
                children: [
                  Text(
                    tr("recycle_guide.empty"),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, size: 20, color: textDark),
                  ),
                  Text(
                    tr("recycle_guide.clean"),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.arrow_forward, size: 20, color: textDark),
                  ),
                  Text(
                    tr("recycle_guide.sqush"),
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Bottles Illustration
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset("assets/icon/recycling_guide_bottle1.png")
                  ),
                  const SizedBox(width: 40),
                  // 模擬壓扁的瓶子
                  SizedBox(
                    height: 60,
                    child: Image.asset("assets/icon/recycling_guide_bottle2.png")
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 4. Green Check List
              _buildCheckItem(tr("recycle_guide.items.transparent_bottles")),
              _buildCheckItem(tr("recycle_guide.items.empty_bottles")),
              _buildCheckItem(tr("recycle_guide.items.squash_bottles")),
              _buildCheckItem(tr("recycle_guide.items.keep_cap_on")),
              _buildCheckItem(tr("recycle_guide.items.close_up")),

              const SizedBox(height: 30),

              // 5. Bags Illustration
              Row(
                children: [
                  SizedBox(width: 10),
                  // Correct Bag
                  Image.asset("assets/icon/recycling_guide_bag1.png", width: 100),
                  const SizedBox(width: 40),
                  // Incorrect Bag

                  Image.asset("assets/icon/recycling_guide_bag2.png", width: 100),
                ],
              ),
              const SizedBox(height: 20),

              // 6. Red Cross List
              _buildCrossItem(tr("recycle_guide.items.dont_overfill")),
              _buildCrossItem(tr("recycle_guide.items.dont_attach_item")),

              const SizedBox(height: 30),

              // 7. Bottom Info Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA), // 極淺灰背景
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Things to keep in mind',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '"Leftover products, drinks make high-quality recycling more difficult. So we rely on you to apply the recycling guide properly!"',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget: 綠色勾勾列表項
  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: checkGreen, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget: 紅色叉叉列表項
  Widget _buildCrossItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.close, color: Colors.red, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}