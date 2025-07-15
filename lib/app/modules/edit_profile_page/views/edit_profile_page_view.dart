import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/edit_profile_page_controller.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';


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

  final Color primaryColor = const Color(0xFFEC407A);

  @override
  Widget build(BuildContext context) {
    usernameController.text = controller.username.value;
    oldUsername = controller.username.value;

    selectedTrimester.value = controller.trimester.value;
    selectedUsia.value = controller.usiaKehamilan.value;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Edit Profil'),
        centerTitle: true,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Routes.PROFILE_PAGE);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _buildProfileImage()),
              const SizedBox(height: 24),
              _buildTextField('Username', usernameController),
              const SizedBox(height: 20),
              _buildDropdown('Trimester', selectedTrimester, trimesterOptions),
              const SizedBox(height: 20),
              _buildDropdown('Usia Kehamilan', selectedUsia, usiaKehamilanOptions),
              const SizedBox(height: 30),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Obx(() {
        final imagePath = controller.photoUrl.value;
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[200],
              backgroundImage: imagePath.isNotEmpty
                  ? (imagePath.startsWith('http')
                  ? NetworkImage(imagePath)
                  : FileImage(File(imagePath)) as ImageProvider)
                  : null,
              child: imagePath.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: const Icon(Icons.camera_alt, size: 18, color: Colors.black54),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }

  Widget _buildDropdown(String label, RxString selectedValue, List<String> options) {
    return Obx(() => DropdownButtonFormField<String>(
      value: selectedValue.value.isNotEmpty ? selectedValue.value : null,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
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
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: Text(
        'Simpan Perubahan',
        style: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
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
