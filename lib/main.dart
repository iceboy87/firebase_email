import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauth/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';



Future main() async{
  WidgetsFlutterBinding.ensureInitialized();



  if(kIsWeb){
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDJiXYeeD0Wtr1anfeLsDX1ePINlVgo4qM",
            appId: "1:472815163239:web:0e367278639473302041c2",
            messagingSenderId: "406105297801",
            projectId: "fireauth-d8d49"
        )
    );
  }

  //firebase initializing
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:Login()
    );
  }
}
