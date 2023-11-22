import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reclama_app/HomePage.dart';
import 'package:reclama_app/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarUsuario().then((temUsuario) {
      if (temUsuario) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=> const HomePage(),
          ),
        );
      }else {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=> const LoginPage(),
          ),
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: Text('DashboardPage Seja bem vindo')),
    );
  }

  Future<bool> verificarUsuario() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token == null) {
      return false;

    } else {
      return true;
    }

  } 

}