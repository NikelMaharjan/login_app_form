import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
final String email;
SecondScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),

      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop("success");
          },
          child: Text("Go back $email"),
        ),

      ),
    );
  }
}
