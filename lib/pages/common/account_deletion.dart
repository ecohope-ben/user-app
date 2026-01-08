import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_app/auth/index.dart';
import 'package:user_app/utils/time.dart';

import '../../components/register/action_button.dart';
import '../guest/widgets.dart';

class AccountPendingDeletion extends StatelessWidget {
  const AccountPendingDeletion({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, t){
        context.go("/get_start");
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => context.go("/get_start"),
              child: Icon(Icons.close, color: Colors.black)
          ),
        ),
        body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Image.asset("assets/icon/login_logo.png", width: 120),
                  FittedBox(child: TitleText("Your Account has been Deleted", fontSize: 40)),
                  SubTitleText("Your account will be permanently deleted on ${convertDateTimeToString(context, Auth.instance().pendingDeletion)} (30 days from the date you requested cancellation)."),
                  SizedBox(height: 20),
                  ActionButton(
                      "Login with a new account",
                      onTap: () async {
                        context.go("/get_start");
                      }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'support@ecohopeltd.com',
                            );
                            if (await canLaunchUrl(emailLaunchUri)) {
                              await launchUrl(emailLaunchUri);
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                              text: tr("please_contact_at"),
                              children: [
                                TextSpan(
                                  text: "support@ecohopeltd.com",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),

                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr("if_need_help")),
                    ],
                  )
                ],
              ),
            )
      ),
    );
  }
}
