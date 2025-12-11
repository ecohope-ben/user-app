import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/subscription_cubit.dart';
import 'package:user_app/style.dart';
import 'package:user_app/utils/pop_up.dart';

import '../../auth/index.dart';
import '../../components/common/explore_banner.dart';
import '../subscription/manage/list.dart';

class SettingsPage extends StatefulWidget {
  final SubscriptionListLoaded subscriptionState;
  const SettingsPage(this.subscriptionState, {super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurple,
      appBar: AppBar(
        backgroundColor: const Color(0xFF422883),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // 1. 綠色推廣橫幅
              ExploreBanner(),

              const SizedBox(height: 20),

              // 2. 白色設置列表
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  children: [
                    // Subscriptions
                    SettingsTile(
                      title: 'Subscriptions',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Join Now', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                      onTap: (){
                        if(widget.subscriptionState is SubscriptionDetailAndListLoaded){
                          context.push("/subscription/manage/list", extra: SubscriptionManageTarget.manage);
                        }else {
                          context.push("/subscription/list");
                        }
                      }
                    ),
                    _buildDivider(),

                    // Language
                    SettingsTile(
                      title: 'Language',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('English', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          SizedBox(width: 8),
                          Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.grey),
                        ],
                      ),
                    ),
                    _buildDivider(),

                    // Recycle Pick Up History
                    SettingsTile(title: 'Recycle Pick Up History', onTap: () => context.push("/order/history")),
                    _buildDivider(),

                    // Transaction History
                    SettingsTile(title: 'Transaction History', onTap: () => context.push("/payments/history"),),
                    _buildDivider(),

                    // FAQ & Feedback
                    SettingsTile(title: 'FAQ & Feedback'),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  children: [
                    SettingsTile(
                        title: 'Logout',
                      onTap: (){
                          showPopup(
                              context,
                            title: "確認登出？",
                            onConfirm: (){
                              Auth.instance().logout();
                              context.go("/get_start");
                            }
                          );
                      },
                    ),
                  ],
                )
              ),
              // 3. 底部鏈接
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Terms & Privacy policy',
                  style: TextStyle(
                    color: Colors.white70,
                    decoration: TextDecoration.underline,
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

  // 構建分隔線
  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 0.5, indent: 16, endIndent: 16, color: Colors.grey);
  }

  // 構建頂部的綠色推廣 Banner
  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1D5A4F), Color(0xFF208C6E)], // 深綠到淺綠漸變
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(0), // 圖片看起來像是直角或者很小的圓角
      ),
      child: Row(
        children: [
          // 左側圖標
          const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          // 中間文字
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Limited Offer, Join Now',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: 4),
                Text(
                  'Free Trial available',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 右側按鈕
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF222222), // 深色按鈕背景
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }
}

// 可復用的列表項組件
class SettingsTile extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  const SettingsTile({
    super.key,
    this.onTap,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}