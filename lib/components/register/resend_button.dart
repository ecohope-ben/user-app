import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/login_cubit.dart';
import '../../blocs/registration_cubit.dart';
import '../../style.dart';

enum ResendButtonCubitType {
  registration,
  login,
}

enum ResendButtonChannelType {
  email,
  phone,
}

class ResendButton extends StatefulWidget {
  final VoidCallback onResend;
  final ResendButtonCubitType cubitType;
  final ResendButtonChannelType channelType;

  const ResendButton(
      this.onResend, {
        super.key,
        this.cubitType = ResendButtonCubitType.registration,
        this.channelType = ResendButtonChannelType.email,
      });

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton> {
  Timer? _countdownTimer;
  int _countdown = 0;

  void _startCountdown() {
    _countdown = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  DateTime? _getOtpSentAt() {
    if (widget.cubitType == ResendButtonCubitType.registration) {
      final state = context.read<RegistrationCubit>().state;
      if (state is RegistrationInProgress) {
        if (widget.channelType == ResendButtonChannelType.email) {
          return state.registration.email.otpSentAt;
        } else {
          return state.registration.phone.otpSentAt;
        }
      }
    } else {
      final state = context.read<LoginCubit>().state;
      if (state is LoginInProgress) {
        return state.login.email.otpSentAt;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to RegistrationCubit if needed
    Widget child = widget.cubitType == ResendButtonCubitType.registration
        ? BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationInProgress) {
          final otpSentAt = widget.channelType == ResendButtonChannelType.email
              ? state.registration.email.otpSentAt
              : state.registration.phone.otpSentAt;
          if (otpSentAt != null) {
            _startCountdown();
          }
        }
      },
      child: _buildButton(),
    )
        : _buildButton();

    // Listen to LoginCubit if needed
    if (widget.cubitType == ResendButtonCubitType.login) {
      child = BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginInProgress && state.login.email.otpSentAt != null) {
            _startCountdown();
          }
        },
        child: child,
      );
    }

    return child;
  }

  Widget _buildButton() {
    return TextButton(
      onPressed: _countdown > 0 ? null : widget.onResend,
      child: Text(
        _countdown > 0
            ? tr("register.resend_at", args: [_countdown.toString()])
            : tr("register.resend"),
        style: TextStyle(
          color: _countdown > 0 ? Colors.grey : blueRegisterText,
        ),
      ),
    );
  }
}