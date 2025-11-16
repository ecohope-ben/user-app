import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/pages/guest/register/steps/email_verify.dart';
import 'package:user_app/pages/guest/register/steps/phone_verify.dart';
import 'package:user_app/pages/guest/register/widgets.dart';
import '../../../components/register/stepper.dart';
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

  final stepProgressController = StepProgressController(totalSteps: 3, initialStep: 0);

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
            if(state is RegistrationInProgress && (state.registration.stage == RegistrationStage.phoneInput || state.registration.stage == RegistrationStage.phoneVerification)){
              stepProgressController.setCurrentStep(1);
            }else if(state is RegistrationCompleted){
              stepProgressController.setCurrentStep(2);
            }else if (state is RegistrationError){
              final scaffold = ScaffoldMessenger.of(context);
              scaffold.showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              if(state.registration != null){
                context.read<RegistrationCubit>().update(RegistrationInProgress(
                  registration: state.registration!,
                  stepToken: state.registration!.tokens.step
                ));
              }else if(state.httpCode == 401){
                context.read<RegistrationCubit>().update(RegistrationInitial());
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                spacing: 48,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterStepper(stepProgressController),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child:  (state is RegistrationInProgress || state is RegistrationCompleted) ? _buildRegisterSection(context, state) : _buildLoading(),
                  )
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

  Widget _buildRegisterSection(BuildContext context, RegistrationState state){

    if(state is RegistrationInProgress){
      RegistrationStage stage = state.registration.stage;
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
          return CreateProfileStep();
      }
    }else if(state is RegistrationCompleted){
      return CreateProfileStep();
    }else return Container();


  }

}
