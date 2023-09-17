import 'package:companeies_project/bloc/profile_bloc.dart';
import 'package:companeies_project/provider/internet_provider.dart';
import 'package:companeies_project/provider/sign_in_provider.dart';
import 'package:companeies_project/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
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
        ChangeNotifierProvider(
          create: ((context) => SignInProvider()),
        ),
        ChangeNotifierProvider(
          create: ((context) => InternetProvider()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: ((context) => ProfileBloc()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData.light(),
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
