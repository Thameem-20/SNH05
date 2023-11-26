import 'package:flutter/material.dart';
import './scan.dart';
import './newCam.dart';

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Select the Category'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                child: Text(
                  "Select the Category",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => newCamera()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                  child: Text('Math '),
                ),
              ),

              SizedBox(height: 16), // Add some spacing between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                  child: Text('Birds'),
                ),
              ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                  child: Text('Animals'),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CameraPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                  child: Text('Insects'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
