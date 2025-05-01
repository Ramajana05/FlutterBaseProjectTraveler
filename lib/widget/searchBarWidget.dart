import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../screen/otherScreen/cameraScreen.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final bool showQrIcon;

  const SearchBarWidget({
    Key? key,
    required this.controller,
    required this.onSearch,
    this.showQrIcon = true,
  }) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late CameraDescription myCamera;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();

    setState(() {
      myCamera = cameras.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              style: TextStyle(fontSize: 14.0, height: 1),
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(),
                prefixIcon: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
                fillColor:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.grey[800]
                        : Colors.grey[200],
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 8.0,
                ),
              ),
            ),
          ),
          if (widget.showQrIcon && myCamera != null) ...[
            SizedBox(width: 10.0),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(camera: myCamera),
                  ),
                );
              },
              child: Image.asset(
                'assets/icons/qr.png',
                width: 24,
                height: 24,
                color:
                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? Colors.white
                        : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
