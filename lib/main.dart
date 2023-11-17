import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_buds/screens/feed_screen.dart';
import 'package:social_buds/widgets/theme_provider.dart';

import 'firebase_options.dart';
import 'screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(ChangeNotifierProvider<ThemeProvider>(
    create: (_)=>ThemeProvider()..initialize(),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  
 static Widget getScreenId(){
    return StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if(snapshot.hasData){
        return FeedScreen(currentUserId: snapshot.data!.uid,);
      }else {
        return WelcomeScreen();
      }
    }
    );
  }
  
  @override
  Widget build(BuildContext context){
    return Consumer<ThemeProvider>(
      builder: (context,Provider,child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: getScreenId(),
          darkTheme: ThemeData.dark(),
          themeMode: Provider.themeMode,
        );
      }
    );
  }
}

