import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  final Function onImagePicked;
  const ProfileImagePicker({super.key, required this.onImagePicked});

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  String? profilePhoto;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  // 🔹 Load saved image from SharedPreferences
  Future<void> _loadProfilePhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profilePhoto = prefs.getString('profilePhoto');
    });
  }

  // 🔹 Pick image and update in real-time
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final base64Image = base64Encode(Uint8List.fromList(bytes));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profilePhoto', base64Image);

      // ✅ Update UI instantly
      setState(() {
        profilePhoto = base64Image;
      });

      // ✅ Notify the parent widget to update profile image
      widget.onImagePicked();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        profilePhoto != null && profilePhoto!.isNotEmpty
            ? CircleAvatar(
                radius: 50,
                backgroundImage: MemoryImage(base64Decode(profilePhoto!)),
              )
            : const CircleAvatar(
                radius: 50, child: Icon(Icons.person, size: 50)),
        TextButton(
          onPressed: _pickImage,
          child: const Text("Change Profile Picture"),
        ),
      ],
    );
  }
}
