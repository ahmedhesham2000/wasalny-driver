import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasalny_driver/dataprovider.dart';
import 'package:wasalny_driver/globalvariables.dart';
import 'package:wasalny_driver/screens/loginPage.dart';
import 'package:wasalny_driver/screens/mainPage.dart';
import 'package:wasalny_driver/screens/regitrattionpage.dart';
import 'package:wasalny_driver/widgets/notificationDialog.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  user = await FirebaseAuth.instance.currentUser;
  runApp( MyApp());

}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  await Firebase.initializeApp();

  print("Handling a background message: ${message.data}");
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context)=> AppData()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity
        ),
        routes: {
          MainPage.routName:(context)=>MainPage(),
          RegistrationPage.routName:(context) => RegistrationPage(),
          LoginPage.routName:(context)=>LoginPage(),

        },
        initialRoute:LoginPage.routName


      ),
    );
  }
}