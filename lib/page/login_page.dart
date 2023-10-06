import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gd_modul_bloc_1212/bloc/form_submission_state.dart';
import 'package:gd_modul_bloc_1212/bloc/login_bloc.dart';
import 'package:gd_modul_bloc_1212/bloc/login_event.dart';
import 'package:gd_modul_bloc_1212/bloc/login_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if(state.formSubmissionState is SubmissionSuccess){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Success'),
              ),
            );
          }
          if(state.formSubmissionState is SubmissionFailed){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state.formSubmissionState as SubmissionFailed)
                  .exception
                  .toString())
              ),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                body: Form(
                  key: formKey,
                  child: Padding(
                    padding: 
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: 'Username',
                          ),
                          validator: (value) => 
                              value == '' ? 'Please enter your username' : null,
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: (){
                                context.read<LoginBloc>().add(
                                    IsPasswordVisibleChanged(),
                                  );
                              },
                              icon: Icon(
                                state.isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                  color: state.isPasswordVisible 
                                    ? Colors.grey 
                                    : Colors.blue,
                              ),
                            ),
                          ),
                          obscureText: state.isPasswordVisible,
                          validator: (value) => 
                              value == '' ? 'Please enter your password' : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (){
                              if(formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(
                                  FormSumitted(
                                    username: usernameController.text,
                                    password: passwordController.text
                                  ),
                                );
                              }
                            },
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                                child: state.formSubmissionState is FormSubmitting ? const CircularProgressIndicator(
                                  color: Colors.white)
                                  : const Text("Login"),
                            ),
                          ),
                        ),
                      ],
                    ),  
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}