// ignore_for_file: prefer_const_constructors


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ns_ideas/settings.dart';
import 'package:ns_ideas/test.dart';
import 'authPage.dart';
import 'electronicProjects.dart';
import 'firebase_options.dart';
import 'functions.dart';
import 'homepage.dart';
import 'notification.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      title: 'NS Ideas',
      theme: ThemeData(
        useMaterial3: true,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return bottomBarSelection();
            } else {
              return LoginPage();
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}

class bottomBarSelection extends StatefulWidget {
  const bottomBarSelection({super.key});

  @override
  State<bottomBarSelection> createState() => _bottomBarSelectionState();
}

class _bottomBarSelectionState extends State<bottomBarSelection> {
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Colors.orangeAccent.withOpacity(0.1),
        //     Colors.blue.withOpacity(0.2),
        //     Colors.deepPurpleAccent.withOpacity(0.12),
        //   ],
        // ),
      ),
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(child: _buildPage(_currentIndex)),
        //
        // bottomNavigationBar: SafeArea(
        //   child: SizedBox(
        //     height: 50,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: [
        //         InkWell(
        //             onTap: (){
        //           _currentIndex=0;
        //         },
        //             child: Icon(Icons.home,color: Colors.white,)
        //         ),
        //         // Icon(Icons.category_outlined,color: Colors.white,),
        //         // Icon(Icons.favorite_border,color: Colors.white,),
        //         InkWell(
        //             onTap: (){
        //           setState(() {
        //             _currentIndex=3;
        //           });
        //         },
        //             child: Icon(Icons.person,color: Colors.white,)),
        //       ],
        //     )
        //   ),
        // ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (_currentIndex) {

      case 0:
        return StreamBuilder<List<ProjectsConvertor>>(
          stream: readProjectsConvertor(
              "projectsInfo", "allProjectsInfo", "allProjectsInfo"),
          builder: (context, snapshot) {
            final subjects = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 0.3,
                    color: Colors.cyan,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return const Text("Error with server");
                } else {
                  if (subjects != null) {
                    return HomePage(data: subjects);
                  } else {
                    return const Text("No data available"); // Handle the case when subjects is null.
                  }
                }
            }
          },
        );
      case 3:
        return settings();

      default:
        return Container();
    }
  }
}


