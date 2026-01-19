import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:step_progress/step_progress.dart';

class RegisterStepper extends StatefulWidget {
  final StepProgressController stepProgressController;
  const RegisterStepper(this.stepProgressController, {super.key});

  @override
  State<RegisterStepper> createState() => _RegisterStepperState();
}

class _RegisterStepperState extends State<RegisterStepper> {

  @override
  Widget build(BuildContext context) {
    return StepProgress(
      totalSteps: 3,
      stepNodeSize: 24,
      controller: widget.stepProgressController,
      nodeIconBuilder: (index, completedStepIndex) {
        //step completed
        if (index <= completedStepIndex) {
          return Image.asset("assets/icon/steper-done.png");
        } else {
          return Image.asset("assets/icon/steper-outlined.png");
        }
      },
      nodeTitles: [
        tr("register.email"),
        tr("register.phone"),
        tr("register.profile"),
      ],

      padding: const EdgeInsets.all(10),

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
          maxWidth: 80,
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
    );
  }
}
