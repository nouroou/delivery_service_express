import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sh_express_transport/screens/home_screen.dart';
import 'package:sh_express_transport/screens/login_screen.dart';
import 'firebase_options.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCFVqBti7G_qUsqj0ILWvZ5VOSR3c4RNKY",
            authDomain: "sh-express-transport.firebaseapp.com",
            projectId: "sh-express-transport",
            storageBucket: "sh-express-transport.appspot.com",
            messagingSenderId: "1060938454449",
            appId: "1:1060938454449:web:0e1124795f355aae1c1990",
            measurementId: "G-MPDMY0CDTH"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider())
  ]
  ,child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget checkIfSignedIn() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MaterialApp(
            title: 'SH Express Transport',
                              debugShowCheckedModeBanner: false,

            theme: ThemeData(
                colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    secondary: Colors.lightBlueAccent,
                    onSecondary: Colors.white,
                    error: Colors.redAccent,
                    onError: Colors.white,
                    background: Colors.white,
                    onBackground: Colors.black,
                    surface: Colors.white,
                    onSurface: Colors.black87),
                hoverColor: Colors.black12,
                splashColor: Colors.lightBlue,
                disabledColor: Colors.grey,
                iconTheme: const IconThemeData(color: Colors.black38),
                primaryIconTheme: const IconThemeData(color: Colors.blue),
                appBarTheme:
                    const AppBarTheme(color: Colors.transparent, toolbarHeight: 89),
                outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)))),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)))),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)))),
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Colors.black.withOpacity(0.07),
                  filled: true,
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: Colors.blueAccent, width: 1)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Colors.redAccent.shade200, width: 0.5)),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: const BorderSide(color: Colors.red, width: 1)),
                )),
            home: checkIfSignedIn());
      }
    );
  }
}
