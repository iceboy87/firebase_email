import 'package:flutter/material.dart';
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome To Carigalan Show",
          style: TextStyle(
              fontWeight: FontWeight.bold),),
      ),
      body: Center(
          child:
          Text("Onnu Illa Unnoda Velaya poitu paru",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white),)),

    );
  }
}
