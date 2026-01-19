import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeLocalePopup extends StatefulWidget {
  const ChangeLocalePopup({super.key});

  @override
  State<ChangeLocalePopup> createState() => _ChangeLocalePopupState();
}

class _ChangeLocalePopupState extends State<ChangeLocalePopup> {
  // 封裝語言選項組件
  Widget _buildLanguageOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          // 選中時顯示淺灰色背景
          color: isSelected ? const Color(0xFFF2F2F2) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected)
              const Icon(Icons.check, color: Colors.black, size: 24),
            if (isSelected) const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            // 如果選中，為了保持文字置中，右邊放一個透明占位
            if (isSelected) const SizedBox(width: 34),
          ],
        ),
      ),
    );
  }

  String selectedLanguage = 'ENGLISH';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        // width: 350, // 設定固定寬度
        child: Column(
          mainAxisSize: MainAxisSize.min, // 根據內容自動高度
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Choose a language/選擇語言',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // 語言選項：英文
            _buildLanguageOption(
              label: 'ENGLISH',
              isSelected: selectedLanguage == 'ENGLISH',
              onTap: () {
                setState(() => selectedLanguage = 'ENGLISH');
              },
            ),

            // 語言選項：繁體中文
            _buildLanguageOption(
              label: '繁體中文',
              isSelected: selectedLanguage == '繁體中文',
              onTap: () {
                setState(() => selectedLanguage = '繁體中文');
              },
            ),

            const SizedBox(height: 30),

            // Confirm 按鈕
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // 黑色背景
                  foregroundColor: Colors.white, // 白色文字
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // 圖片中按鈕邊角較方
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  print('Selected: $selectedLanguage');
                  Navigator.pop(context); // 關閉彈窗
                },
                child: Text(
                  tr("confirm"),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}