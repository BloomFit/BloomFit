import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import '../controllers/edit_profile_page_controller.dart';
import 'package:image_picker/image_picker.dart';
class EditProfilePageView extends GetView<EditProfilePageController> {
  EditProfilePageView({super.key});

  final TextEditingController usernameController = TextEditingController();
  late String oldUsername;

  final RxString selectedTrimester = ''.obs;
  final RxString selectedUsia = ''.obs;

  final List<String> trimesterOptions = [
    'Trimester 1',
    'Trimester 2',
    'Trimester 3'
  ];

  final List<String> usiaKehamilanOptions = [
    '0-13 minggu',
    '14-26 minggu',
    '27-40 minggu',
  ];

  @override
  Widget build(BuildContext context) {
    usernameController.text = controller.username.value;
    oldUsername = controller.username.value;

    selectedTrimester.value = controller.trimester.value;
    selectedUsia.value = controller.usiaKehamilan.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: 16),
            _buildTextField('Username', usernameController),
            const SizedBox(height: 16),
            _buildDropdown('Trimester', selectedTrimester, trimesterOptions),
            const SizedBox(height: 16),
            _buildDropdown('Usia Kehamilan', selectedUsia, usiaKehamilanOptions),
            const SizedBox(height: 32),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () => _pickImage(),
      child: Obx(() {
        final imagePath = controller.photoUrl.value;
        return CircleAvatar(
          radius: 50,
          backgroundImage: imagePath.isNotEmpty
              ? (imagePath.startsWith('http')
              ? NetworkImage(imagePath)
              : FileImage(File(imagePath)) as ImageProvider)
              : const AssetImage('assets/default_profile.png'),
          child: Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.camera_alt,
                size: 15,
                color: Colors.grey[800],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(
      String label, RxString selectedValue, List<String> options) {
    return Obx(() => DropdownButtonFormField<String>(
      value: selectedValue.value.isNotEmpty ? selectedValue.value : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) selectedValue.value = value;
      },
    ));
  }

  Widget _saveButton() {
    return ElevatedButton(
      onPressed: () async {
        String newUsername = usernameController.text;

        print('Username sebelumnya: $oldUsername');
        print('Username baru: $newUsername');

        await controller.saveUserData(
          newUsername,
          controller.photoUrl.value,
          newTrimester: selectedTrimester.value,
          newUsiaKehamilan: selectedUsia.value,
        );

        Get.snackbar(
          'Sukses',
          'Perubahan profil berhasil disimpan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.PROFILE_PAGE);
      },
      child: const Text('Simpan Perubahan'),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.photoUrl.value = pickedFile.path;
    }
  }
}
