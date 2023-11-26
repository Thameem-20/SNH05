import 'package:flutter/material.dart';
import './scan.dart';
import './category.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Origami(),
  ));
}

class Origami extends StatelessWidget {
  const Origami({super.key});

  @override
  Widget build(BuildContext context) {
    void doNothing() {}

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Origami Detector",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 215, 33),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 350.0, 0, 0),
              child: const Text(
                "Get Started",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
              child: Text("Get started to enjoy our feature for free!!"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 15.0),
              ),
              child: const Text(
                "Start",
                style: TextStyle(color: Colors.white, fontSize: 30.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
