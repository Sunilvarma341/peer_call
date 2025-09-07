import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peer_call/core/pages.dart';
import 'package:peer_call/presentation/blocs/auth_bloc/auth_export.dart';
import 'package:peer_call/presentation/widgets/app_snackbar.dart';
import 'package:peer_call/presentation/widgets/custom_text_field.dart';
import 'package:peer_call/presentation/widgets/p_scaffold.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return PScaffold(
      appBar: AppBar(title: const Text('Sign Up'), centerTitle: true),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.go(PAGE.bottomNav.path);
          } else if (state is Unauthenticated) {
            log(state.message ?? "Signup failed");
            AppSnackbar.show(state.message ?? "Signup failed");
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
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
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
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
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomeTextFormField(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        bloc.add(SignUpRequested(
                          emailController.text,
                          passwordController.text,
                        ));
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      context.go(PAGE.login.path);
                    },
                    child: const Text("Already have an account? Login"),
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