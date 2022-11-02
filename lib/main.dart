import 'package:auth_app/services/authentication_service.dart';
import 'package:auth_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'auth/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => DatabaseService(),),
        Provider<AuthenticationService>(create: (_) => AuthenticationService(FirebaseAuth.instance),),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanged, initialData: null,)
      ],
      child: MaterialApp(
        home: MainPage(),
      ),
    );
  }
}
