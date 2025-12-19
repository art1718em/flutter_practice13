import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_practice13/features/auth/logic/auth_cubit.dart';
import 'package:flutter_practice13/features/auth/logic/auth_state.dart';
import 'package:flutter_practice13/features/profile/logic/profile_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.read<ProfileCubit>().loadProfile();
          context.go('/');
        } else if (state.status == AuthStatus.unauthenticated) {
          context.go('/auth/login');
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

