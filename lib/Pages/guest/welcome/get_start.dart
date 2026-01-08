import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:user_app/utils/snack.dart';
import '../../../style.dart';

class GetStartPage extends StatefulWidget {
  const GetStartPage({super.key});

  @override
  State<GetStartPage> createState() => _GetStartPageState();
}

class _GetStartPageState extends State<GetStartPage> {
  bool _agreeToTerms = false;
  bool _agreeToMarketingUse = false;

  @override
  Widget build(BuildContext context) {
    const Color kBackgroundColor = Color(0xFF1E1E1E);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/welcome_bg.png') as ImageProvider,
                fit: BoxFit.cover
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2C2C2C), Color(0xFF121212)],
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Language switcher icon at top right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PopupMenuButton<Locale>(
                        icon: Row(
                          children: [
                            const Icon(
                              Icons.language,
                              color: Colors.white,
                              size: 28,
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.white)
                          ],
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
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
                    ],
                  ),
                  const Spacer(flex: 1),

                  Image.asset("assets/icon/white_logo.png", width: 180),

                  const Spacer(flex: 1),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                          children: [
                            TextSpan(text: tr("welcome.page3.title1")),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Transform.rotate(
                                angle: 0.05, // rotate
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                  decoration: BoxDecoration(
                                    color: welcomeWordsBg,
                                  ),
                                  child: Transform.rotate(
                                    angle: -0.05, // rotate
                                    child: Text(
                                      tr("welcome.page3.highlight"),
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    tr("welcome.page3.title2"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Get Started button
                  Container(
                      width: double.infinity,
                      height: 40,
                      // padding: const EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          bottom: BorderSide(
                            color: blueTextUnderline,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: TextButton(
                        onPressed:() {
                          if (_agreeToTerms) {
                            context.push("/register");
                          }else{
                            popSnackBar(context, tr("validation.agree_terms"));
                          }
                        },
                        child: Text(tr("register.register_now"), textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ), ),
                      ),
                    ),


                  const SizedBox(height: 18),

                  // Login
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      children: [
                        TextSpan(text: tr("login.already_have_account")),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: InkWell(
                            onTap: () => context.push("/login"),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                tr("login.title"),
                                style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Terms and Privacy checkboxes
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreeToTerms = !_agreeToTerms;
                            });
                          },
                          child: Text(
                            tr("have_read_terms_n_pp"),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToMarketingUse,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreeToMarketingUse = value ?? false;
                          });
                        },
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreeToMarketingUse = !_agreeToMarketingUse;
                            });
                          },
                          child: Text(
                            tr("agree_marketing_purpose"),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}

