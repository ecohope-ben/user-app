import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../blocs/profile_cubit.dart';
import '../../../../components/register/action_button.dart';
import '../../../../components/register/profile_input.dart';
import '../../widgets.dart';

class CreateProfileStep extends StatelessWidget {
  const CreateProfileStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if(state is ProfileUpdateSuccess){
            print("--update profile success");
            // Goto login page
            context.go("/home");
          }else if (state is ProfileError){
            final scaffold = ScaffoldMessenger.of(context);
            scaffold.showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/icon/register_profile.png", width: 140),
              TitleText(tr("register.profile")),
              SubTitleText(tr("register.profile_description")),
              ProfileInput()
            ],
          );
        },
      ),
    );
  }
}
