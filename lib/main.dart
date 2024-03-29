import 'package:assignment_project/profile.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'mainmenu.dart';
import 'database.dart';
import 'addgroup.dart';
import 'themes.dart';
import 'settings.dart';

void main() async {
  await DatabaseHelper.getDBConnector();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoviXP',
      theme: AppThemes.light(),
      darkTheme: AppThemes.dark(),
      themeMode: AppThemes.currentTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage(
              title: 'Sign In',
            ),
        '/SignUp': (context) => const SignUpPage(title: 'Sign Up'),
        '/MainMenu': (context) => MainMenuPage(
              title: 'Main Menu',
            ),
        '/AddGroup': (context) => AddGroupPage(title: 'Add Group'),
        '/Profile': (context) => ProfilePage(title: 'Profile'),
        '/Settings': (context) => SettingsPage(title: 'Settings'),
      },
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.title});
  final String title;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  _SignInPageState();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://images.unsplash.com/photo-1598899134739-24c46f58b8c0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw1fHxtb3ZpZXxlbnwwfHx8fDE3MDQ0Njg0MDd8MA&ixlib=rb-4.0.3&q=80&w=1080',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: const Color.fromARGB(255, 59, 255, 157),
                  );
                },
              ),
            ),
            const Text(
              'Username',
            ),
            TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const Text(
              'Password',
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  //Sign up button
                  onPressed: () {
                    passwordController.clear();
                    usernameController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(
                          title: 'Sign Up',
                        ),
                      ),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
                ElevatedButton(
                  //Log in button
                  onPressed: () {
                    attemptLogin();
                  },
                  child: const Text('Log In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> attemptLogin() async {
    int loginResult = await DatabaseHelper.attemptLogin(
        usernameController.text, passwordController.text);
    if (loginResult == -1) {
      displayLoginError();
    } else if (loginResult == 1) {
      login();
    }
  }

  void displayLoginError() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: const Text("Wrong username or password."),
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

  //Logs the user in
  void login() {
    passwordController.clear();
    usernameController.clear();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainMenuPage(
          title: 'Main Menu',
        ),
      ),
    );
  }
}
