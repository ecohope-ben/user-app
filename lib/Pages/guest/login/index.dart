import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_app/auth/index.dart';
import 'package:user_app/blocs/login_cubit.dart';
import 'package:user_app/models/login_models.dart';
import 'package:user_app/utils/validator.dart';

import '../../../components/register/action_button.dart';
import '../../../components/register/text_input.dart';
import '../widgets.dart';

import 'package:user_app/routes.dart';

class LoginIndex extends StatefulWidget {
  const LoginIndex({super.key});

  @override
  State<LoginIndex> createState() => _LoginIndexState();
}

class _LoginIndexState extends State<LoginIndex>{
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Auth.instance().removeAllStorage();
      if (mounted) {
        context.read<LoginCubit>().startLogin();
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(tr("login.title"), style: TextStyle(color: Colors.black)),
        leading: InkWell(
            onTap: () => context.pop(),
            child: Icon(Icons.close, color: Colors.black)
        ),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state is LoginInProgress){
            if(state.login.stage == LoginStage.emailVerification){}
          }else if(state is LoginError){
            final login = state.login;
            if(login != null){
              context.read<LoginCubit>().update(LoginInProgress(login: login, stepToken: login.tokens.step));
            }else {
              context.read<LoginCubit>().reset();
              context.read<LoginCubit>().startLogin();
            }
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Image.asset("assets/icon/login_logo.png", width: 120),
                  TitleText(tr("login.welcome"), fontSize: 40),
                  SubTitleText(tr("login.email_description")),
                  TextInput(tr("login.your_email_address"), controller: _emailController, validator: validateEmail),
                  SizedBox(height: 20),
                  ActionButton(
                      tr("login.login_with_otp"),
                      showLoading: context.read<LoginCubit>().state is LoginLoading || context.read<LoginCubit>().state is LoginInProgressLoading,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          // If validation passes, get the email and update registration
                          final email = _emailController.text;

                          final bloc = context.read<LoginCubit>();
                          final result = await bloc.updateEmail(email: email);

                          if(mounted) {
                            if(result) {
                              context.push("/login/verify");
                            }else {
                              context.read<LoginCubit>().reset();
                              context.read<LoginCubit>().startLogin();

                              // retry
                              final result = await bloc.updateEmail(email: email);
                              if(result) {
                                context.push("/login/verify");
                              }
                            }
                          }
                        }
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
            ),
          );
        },
      ),
    );
  }
}

