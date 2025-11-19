import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/routes.dart';

import '../blocs/login_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
          onPressed: (){
            context.push("/login");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => BlocProvider(
            //       create: (_) => LoginCubit(),
            //       child: const LoginEmailPage(),
            //     ),
            //   ),
            // );
          },
          child: Text("Home page, goto Login")
      ),
    );
  }
}
