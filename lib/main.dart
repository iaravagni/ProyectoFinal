import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/pages/google_sign_in_page.dart';
import 'package:provider/provider.dart';

import 'pages/timer_provider.dart';
import 'pages/main_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GoogleSignInProvider()),
          ChangeNotifierProvider(create: (_) => TimerProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            // Set the background color of AlertDialogs to white
            dialogBackgroundColor: Colors.white,
          ),
          home: MainPage(),
        ),
      );
}
