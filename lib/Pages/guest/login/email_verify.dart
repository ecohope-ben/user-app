import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/blocs/login_cubit.dart';
import 'package:user_app/models/login_models.dart';
import 'package:user_app/routes.dart';

import '../../../../components/register/otp_input.dart';
import '../../../../components/register/resend_button.dart';
import '../../../../models/registration_models.dart';
import '../../../../style.dart';
import '../../../utils/pop_up.dart';
import '../../../utils/snack.dart';
import '../../../utils/validator.dart';
import '../widgets.dart';

class LoginEmailVerification extends StatefulWidget {
  const LoginEmailVerification({super.key});

  @override
  State<LoginEmailVerification> createState() => _LoginEmailVerificationState();
}

class _LoginEmailVerificationState extends State<LoginEmailVerification> {
  String? email;

  void _submitOTP(String verificationCode) {
    context.read<LoginCubit>().verifyEmailOtp(verificationCode);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<LoginCubit>().state;

        print("--state2: ");
        print(state);
        if(state is LoginInProgress && state.login.email.otpSentAt == null) {
          print("--state is LoginInProgress");
          email = state.login.email.value;
          sendOTP();
        }
      }
    });
    super.initState();
  }

  void sendOTP() {
    context.read<LoginCubit>().requestEmailOtp();
  }

  @override
  Widget build(BuildContext context) {
    print("--find LoginCubit: ${context.read<LoginCubit>()}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: Colors.black)
        ),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if(state is LoginError){
            if(state.login?.stage == LoginStage.failed){
              showForcePopup(
                  context,
                  title: "登入錯誤",
                  message: state.message,
                  confirmText: tr("ok"),
                  onConfirm: (){
                    print("--login error click");

                    printRouteStack(context);
                    context.pop(context);
                    // context.pushNamed
                    // context.pushNamedWithBloc("/", context.read<LoginCubit>()..startLogin());
                  }
              );
            }
            popSnackBar(context, state.message);

          }else if(state is LoginCompleted){
            print("--login complete");
            context.go("/home");
          }

        },
        builder: (context, state) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Image.asset("assets/icon/login_logo.png", width: 120),
                  TitleText(tr("login.welcome"), fontSize: 40),
                  SubTitleText(tr("login.email_description")),
                  SubTitleText(tr("login.please_enter_otp", args: [email ?? ""])),
                  OTPInput(validator: validateOTP, submitOTP: _submitOTP, showLoading: context.read<LoginCubit>().state is LoginInProgressLoading),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr("register.dont_receive_code")),
                      ResendButton(
                        sendOTP,
                        cubitType: ResendButtonCubitType.login,
                        channelType: ResendButtonChannelType.email,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () => context.pop(),
                          child: Text(tr("register.edit_email", args: [email ?? ""]),
                              style: TextStyle(color: blueRegisterText))
                      ),
                    ],
                  ),
                ],
              ),
            );
        },
      ),
    );
  }
}
