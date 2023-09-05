import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/localidad_page.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/partido_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        //body: LocalidadPage(),
        //body: LoginPage(),
        body: PartidoPage(),
      ),
    );
  }
}
