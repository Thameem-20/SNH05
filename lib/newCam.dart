import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class newCamera extends StatefulWidget {
  const newCamera({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<newCamera>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _requestPermissions();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }

    status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _sendImageToServer(File? imageFile) async {
    try {
      if (imageFile == null) {
        throw Exception('Image file is null');
      }

      showLoadingDialog(context); // Show loading indicator

      var uri = Uri.parse('https://7cd5-34-125-216-120.ngrok.io/image_similarity');
      var request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile(
          'image',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: 'image.jpg',
        ));

      var response = await http.Response.fromStream(await request.send());

      // Handle the response as needed
      print(response.body);
    } catch (e) {
      print('Error: $e');
      showErrorDialog(context, 'Error sending image to server');
    } finally {
      Navigator.pop(context); // Dismiss loading indicator
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Sending image to server..."),
            ],
          ),
        );
      },
      barrierDismissible: false, // Prevent user from dismissing the dialog
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FlutterCamera(
            color: Colors.amber,
            onVideoRecorded: (value) {
              final path = value.path;
              print('Video Recorded Path: $path');

              // Assuming value is an XFile from the camera, send the image to the server
              File imageFile = File(path);
              _sendImageToServer(imageFile);
            },
          ),
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    _buildScanningAnimation(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningAnimation() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) {
          if (_animation == null) {
            return Container(); // or a placeholder widget
          }

          return Align(
            alignment: Alignment(0, -1 + (_animation!.value * 2)),
            child: Container(
              height: 4,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
