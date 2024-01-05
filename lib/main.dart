// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:client/components/custom_text_field.dart';
import 'package:client/providers/lobbies_provider.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/user_provider.dart';
import 'package:client/values/main_gradient_bg.dart';
import 'package:client/views/main_menu_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<FirebaseApp> _fbApp =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => LobbiesProvider()),
        // ChangeNotifierProvider(create: (context) => LobbyProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFffd452),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: FutureBuilder(
            future: _fbApp,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('You have an error! ${snapshot.error.toString()}');
                return const Text('Something went wrong');
              } else if (snapshot.hasData) {
                //return GameView();
                return const LoginPage();
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DatabaseReference db = FirebaseDatabase.instance.ref();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: mainContainerDecoration,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                      textEditingController: _textEditingController,
                      hintText: 'Enter your username'),
                  const SizedBox(height: 30),
                  Consumer<UserProvider>(
                    builder: (context, model, child) => ElevatedButton(
                        onPressed: () async {
                          final User user =
                              User(username: _textEditingController.text);
                          await user.createUser();
                          model.setUser(user);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainMenuView()));
                        },
                        child: const Text('enter')),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
