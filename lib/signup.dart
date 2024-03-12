import 'package:assignment_project/database.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});
  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

//Sign up page
//Handles the user's input for creating a new account.
class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                //User data input fields
                children: [
                  const Text('Username'),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const Text('Email'),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const Text('Password'),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const Text('Confirm Password'),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                  ),
                  //Sign up button
                  ElevatedButton(
                    child: const Text('Sign Up'),
                    onPressed: () {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                  "Password validation failed, ensure both passwords are the same."),
                              actions: [
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    passwordController.clear();
                                    confirmPasswordController.clear();
                                  },
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        addNewUser();
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              //Back button
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Checks if user already exists, adds new user if not.
  Future<void> addNewUser() async {
    int result = await DatabaseHelper.addNewUser(
        usernameController.text, passwordController.text);
    if (result == -1) {
      //Error, user already exists
      showUniqueUsernameError();
    }
    if (result == 1) {
      returnToLoginMenu();
    }
  }

  //Shows error for if username is not unique.
  void showUniqueUsernameError() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Username is not unique."),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void returnToLoginMenu() {
    Navigator.pop(context);
  }
}
