import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/pages/guest/register/steps/email_verify.dart';
import 'steps.dart';

import '../../../api/registration_api_service.dart';
import '../../../blocs/registration_cubit.dart';
import '../../../models/registration_models.dart';
import 'steps/email_input.dart';
import 'steps/phone_input.dart';

class RegisterIndex extends StatefulWidget {
  const RegisterIndex({super.key});

  @override
  State<RegisterIndex> createState() => _RegisterIndexState();
}

class _RegisterIndexState extends State<RegisterIndex> {

  final stepProgressController = StepProgressController(
      totalSteps: 3, initialStep: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close, color: Colors.black),
      ),
      body: BlocProvider(
        create: (context) => RegistrationCubit(
          apiService: context.read<RegistrationApiService>(),
        )..startRegistration(),
        child: BlocConsumer<RegistrationCubit, RegistrationState>(
          listener: (context, state){
            print("--state: $state");
            if(state is RegistrationInProgress){
              print("--${state.registration.stage.name}");
            }
            if(state is RegistrationInProgress && (state.registration.stage == RegistrationStage.phoneInput || state.registration.stage == RegistrationStage.phoneVerification)){
              print("--stage name: ${state.registration.stage.name}");
              stepProgressController.setCurrentStep(1);
            }else if (state is RegistrationError){
              final scaffold = ScaffoldMessenger.of(context);
              scaffold.showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,

                ),
              );
            }
          },
          buildWhen: (previous, current) {

            // if(previous is RegistrationInProgress && current is RegistrationInProgress){
            //   if(previous.registration.stage == current.registration.stage){
            //     print("--same stage");
            //     print(previous);
            //     print(previous.registration.email.otpSentAt);
            //     print(current);
            //     print(current.registration.email.otpSentAt);
            //     return false;
            //     // if(current.registration.email.otpSentAt == null){
            //     //   return true;
            //     // }else return false;
            //   }
              return true;
            // } else return true;
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                spacing: 48,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepProgress(
                    totalSteps: 3,
                    stepNodeSize: 24,
                    controller: stepProgressController,
                    nodeIconBuilder: (index, completedStepIndex) {
                      //step completed
                      if (index <= completedStepIndex) {
                        return Image.asset("assets/icon/steper-done.png");
                      } else {
                        return Image.asset("assets/icon/steper-outlined.png");
                      }
                    },
                    nodeTitles: const [
                      'Email',
                      'Phone',
                      'Profile'
                    ],
                    padding: const EdgeInsets.all(18),

                    theme: const StepProgressThemeData(
                      shape: StepNodeShape.rectangle,
                      nodeLabelAlignment: StepLabelAlignment.bottom,
                      stepLineSpacing: 20,
                      stepLineStyle: StepLineStyle(
                        lineThickness: 2,
                        foregroundColor: Colors.grey,
                        activeColor: Colors.black,
                        borderRadius: Radius.circular(4),
                      ),
                      nodeLabelStyle: StepLabelStyle(
                        activeColor: Colors.black,
                        defualtColor: Colors.black,
                        titleStyle: TextStyle(fontWeight: FontWeight.bold),
                        margin: EdgeInsets.only(top: 6),
                      ),
                      stepNodeStyle: StepNodeStyle(
                        activeIcon: null,
                        defaultForegroundColor: Colors.transparent,
                        activeForegroundColor: Colors.transparent,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child:  (state is RegistrationInProgress) ? _buildRegisterSection(context, state) : _buildLoading(),
                  ),


                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   spacing: 38,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () => stepProgressController.setCurrentStep(0),
                  //       child: const Text('Prev'),
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: stepProgressController.nextStep,
                  //       child: const Text('Next'),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading(){
      return const Center(
        child: CircularProgressIndicator(),
      );
  }

  Widget _buildRegisterSection(BuildContext context, RegistrationInProgress state){

    // if(state is RegistrationInProgressLoading){
    //   return _buildLoading();
    // }

    RegistrationStage stage = state.registration.stage;

    print("--stage: ${stage.name}");
    // return CreateProfileStep();
    switch (stage) {
      case RegistrationStage.emailInput:
        return EmailInputStep();
      case RegistrationStage.emailVerification:
        return EmailVerificationStep();
      case RegistrationStage.phoneInput:
        return PhoneInputStep();
      case RegistrationStage.phoneVerification:
        return PhoneVerificationStep();
      case RegistrationStage.completed:
        return const Center(
          child: Text('Enter stage'),
        );
    }
  }

}
