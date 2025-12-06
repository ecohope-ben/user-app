import 'package:flutter/material.dart';
import 'package:user_app/style.dart';

class PickUpOrderDetailsPage extends StatelessWidget {
  final String orderId;
  const PickUpOrderDetailsPage(this.orderId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // 返回邏輯
          },
        ),
        title: const Text(
          'Recycle Pick Up Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Order Number Section
              _buildLabel('Order Number'),
              const SizedBox(height: 4),
              const Text(
                '#01234 HJET012389',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),

              // 2. Status Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                color: lightPurple,
                child: Text(
                  'Pick Up Schedule Confirmed',
                  style: TextStyle(
                    color: mainPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(thickness: 1, color: Colors.black12),
              const SizedBox(height: 16),

              // 3. Pick Up Date and Time
              _buildLabel('Pick Up Date and Time'),
              const SizedBox(height: 6),
              _buildValue('24 Oct 2025 | 11:30AM'),

              const SizedBox(height: 20),

              // 4. Pick Up Address
              _buildLabel('Pick Up Address'),
              const SizedBox(height: 6),
              _buildValue(
                  'Chinachem Leighton plaza, 29 Leighton Road,\nCauseway Bay, Hong Kong'),

              const SizedBox(height: 20),
              const Divider(thickness: 1, color: Colors.black12),
              const SizedBox(height: 16),

              // 6. CO2 Reduction Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: lightGreenBg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You have helped to reduce CO2 0.80kg',
                      style: TextStyle(
                        color: darkGreenWord,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                        children: [
                          const TextSpan(text: 'Product Carbon Footprint Study for Plastic Bottle Recycling by '),
                          const TextSpan(
                            text: 'Ecohope',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: '\n0.809 kg CO2 eq. | '),
                          TextSpan(
                            text: 'Verified by SGS',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // 7. Bottom Buttons
              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: OutlinedButton(
              //     onPressed: () {},
              //     style: OutlinedButton.styleFrom(
              //       side: const BorderSide(color: Colors.black),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(4), // 略微圓角，接近直角
              //       ),
              //     ),
              //     child: const Text(
              //       'Change Plan',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Report an issue',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 輔助方法：建立小標籤文字 (灰色)
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54, // 深灰色
      ),
    );
  }

  // 輔助方法：建立數值文字 (黑色加粗)
  Widget _buildValue(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        height: 1.3, // 行高，避免多行時太擠
      ),
    );
  }
}