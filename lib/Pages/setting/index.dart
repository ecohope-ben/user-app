import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadVersionInfo();
  }

  Future<void> _loadVersionInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurple,
      appBar: AppBar(
        backgroundColor: mainPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
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
              ExploreBanner(widget.subscriptionState),

              const SizedBox(height: 20),

              // Settings
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                ),
                child: Column(
                  children: [
                    // Subscriptions
                    SettingsTile(
                      title: tr("subscription.title"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text((widget.subscriptionState.subscriptions.isEmpty) ? 'Join Now' : 'Manage', style: TextStyle(color: Colors.grey, fontSize: 14)),
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
                      title: 'Language/語言',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text('English', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          SizedBox(
                            height: 25,
                            child: PopupMenuButton<Locale>(
                              padding: EdgeInsets.zero,
                              icon: Row(
                                children: [
                                  Text((context.locale == const Locale('en', 'US') ? "English" : "繁體中文"), style: TextStyle(color: Colors.grey, fontSize: 14)),
                                  const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.grey),
                                ],
                              ),
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem<Locale>(
                                  value: const Locale('en', 'US'),
                                  child: Row(
                                    children: [
                                      const Text('English'),
                                      const Spacer(),
                                      if (context.locale == const Locale('en', 'US'))
                                        const Icon(Icons.check, color: Colors.blue, size: 20),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<Locale>(
                                  value: const Locale('zh', 'HK'),
                                  child: Row(
                                    children: [
                                      const Text('繁體中文'),
                                      const Spacer(),
                                      if (context.locale == const Locale('zh', 'HK'))
                                        const Icon(Icons.check, color: Colors.blue, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (Locale locale) {
                                context.setLocale(locale);
                              },
                            ),
                          ),
                          // const SizedBox(width: 8),
                          // const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.grey),
                        ],
                      ),
                    ),
                    _buildDivider(),

                    // Recycle Pick Up History
                    SettingsTile(title: tr("settings.order_history"), onTap: () => context.push("/order/history")),
                    _buildDivider(),

                    // Transaction History
                    SettingsTile(title: tr("settings.transaction_history"), onTap: () => context.push("/payments/history"),),
                    _buildDivider(),

                    // FAQ & Feedback
                    SettingsTile(title: tr("settings.fnq")),
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
                      title: tr("logout.title"),
                      onTap: (){
                          showPopup(
                              context,
                            title: tr("logout.confirm"),
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
              
              const SizedBox(height: 20),
              // App version and build number
              Text(
                'Version $_version ($_buildNumber)',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              
              // 3. 底部鏈接
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Terms & Privacy policy',
                  style: TextStyle(
                    color: Colors.white70,
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