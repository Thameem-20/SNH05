import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FlutterCamera(
            /* Keep the FlutterCamera widget in the Stack's children list */
            color: Colors.amber,
            onVideoRecorded: (value) {
              final path = value.path;
              print('Video Recorded Path: $path');
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
        animation: _animation,
        builder: (context, child) {
          return Align(
            alignment: Alignment(0, -1 + (_animation.value * 2)),
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
