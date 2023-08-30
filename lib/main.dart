import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'searchBar.dart';
import 'textField.dart';
import 'authPage.dart';
import 'homepage.dart';
import 'notification.dart';
import 'saveCartList.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= 600;

bool isMobile(BuildContext context) => MediaQuery.of(context).size.width <= 600;

double Width(BuildContext context) => MediaQuery.of(context).size.width;

double Height(BuildContext context) => MediaQuery.of(context).size.height;

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    NotificationService().initNotification();

  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification);
      }
    });

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {}
      NotificationService().showNotification(
          title: message.notification!.title, body: message.notification!.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSIdeas',

      home: Scaffold(

        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return  LoginPage();
              }
            }),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

