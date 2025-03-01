import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'cropped_image.dart';
import 'package:permission_handler/permission_handler.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ImagePicker _picker = ImagePicker();
  static const platform = MethodChannel('com.example.camera');

  Future<void> pickImage(bool fromGallery) async {
    XFile? image = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );

    if (image != null) {
      final String? imagePath = await cropImage(image);
      if (imagePath != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CroppedImage(imagePath: imagePath),
          ),
        );
      }
    }
  }

  Future<String?> cropImage(XFile image) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Crop Image",
          toolbarColor: Colors.teal,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Crop Image",
        ),
      ],
    );

    return croppedFile?.path;
  }

  Future<void> openNativeCamera() async {
    await requestPermissions();  // ขอสิทธิ์ก่อนการเปิดกล้อง
    try {
      await platform.invokeMethod('openNativeCamera');
    } on PlatformException catch (e) {
      print("Failed to open native camera: '${e.message}'.");
    }
  }

  Future<void> requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final photoLibraryStatus = await Permission.photos.request();

    if (cameraStatus.isGranted && photoLibraryStatus.isGranted) {
      pickImage(false); // เรียกใช้งาน pickImage ต่อไป
    } else {
      _showPermissionError(); // แสดงข้อความหากสิทธิ์ไม่ถูกต้อง
    }
  }

  Future<void> startVideoRecording() async {
  try {
    final String? videoPath = await platform.invokeMethod('startVideoRecording');
    if (videoPath != null) {
      print("Video saved at: $videoPath");
    }
  } on PlatformException catch (e) {
    print("Error: ${e.message}");
  }
}

Future<void> stopVideoRecording() async {
  try {
    final String? videoPath = await platform.invokeMethod('stopVideoRecording');
    if (videoPath != null) {
      print("Video saved at: $videoPath");
    }
  } on PlatformException catch (e) {
    print("Error: ${e.message}");
  }
}


  void _showPermissionError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text("Please grant camera and photo permissions to proceed."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera App'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageButton(
              icon: Icons.photo_library,
              text: 'Pick Gallery',
              color: Colors.blueAccent,
              onTap: () => pickImage(true),
            ),
            const SizedBox(height: 15),
            _buildImageButton(
              icon: Icons.camera_alt,
              text: 'Capture Camera',
              color: Colors.deepPurple,
              onTap: openNativeCamera,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
