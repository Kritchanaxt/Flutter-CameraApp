import 'package:flutter/material.dart';
import 'package:flutter_camerapp/cropped_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final ImagePicker _picker = ImagePicker();

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
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9,
      ],
    );
    return croppedFile?.path;
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
              text: 'Pick Gallery Images',
              color: Colors.blueAccent,
              onTap: () => pickImage(true),
            ),
            const SizedBox(height: 15),
            _buildImageButton(
              icon: Icons.camera_alt,
              text: 'Capture Camera Images',
              color: Colors.deepPurple,
              onTap: () => pickImage(false),
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
