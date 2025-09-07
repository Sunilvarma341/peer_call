import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_call/core/pages.dart';
import 'package:peer_call/presentation/blocs/auth_bloc/auth_export.dart';
import 'package:peer_call/presentation/widgets/app_snackbar.dart';
import 'package:peer_call/presentation/widgets/custom_text_field.dart';
import 'package:peer_call/presentation/widgets/p_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return PScaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go(PAGE.bottomNav.path);
          } else if (state is Unauthenticated) {
            log(state.message ?? "Auth failed");
            AppSnackbar.show(state.message ?? "Auth failed");
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomeTextFormField(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomeTextFormField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      bloc.add(GoogleSignInRequested());
                    },
                    child: const Text(
                      'Google Sign In',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        bloc.add(
                          SignInRequested(
                            emailController.text,
                            passwordController.text,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.go(PAGE.signup.path);
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
