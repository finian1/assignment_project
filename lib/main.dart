import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineGoal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(title: 'Sign In'),
        '/SignUp': (context) => SignUpPage(title: 'Sign Up'),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(
                          title: 'Sign Up',
                        ),
                      ),
                    );
                  },
                  child: const Text('Sign Up'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Log In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
