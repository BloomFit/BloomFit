import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import '../../../constants/colors.dart';
import '../controllers/edit_profile_page_controller.dart';

class EditProfilePageView extends GetView<EditProfilePageController> {
  EditProfilePageView({super.key});

  final TextEditingController usernameController = TextEditingController();

  final List<String> trimesterOptions = ['Trimester 1', 'Trimester 2', 'Trimester 3'];
  final List<String> usiaOptions = [
    '1 Minggu', '2 Minggu', '3 Minggu', '4 Minggu', '5 Minggu',
    '6 Minggu', '7 Minggu', '8 Minggu', '9 Minggu', '10 Minggu',
  ];

  final RxString selectedTrimester = 'Trimester 1'.obs;
  final RxString selectedUsia = '3 Minggu'.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 75);
    if (pickedFile != null) {
      controller.photoUrl.value = pickedFile.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    usernameController.text = controller.username.value;

    return Scaffold(
      backgroundColor: AppColorsDark.fourth,
      appBar: AppBar(
        backgroundColor: AppColorsDark.fourth,
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.offAllNamed(Routes.PROFILE_PAGE);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColorsDark.aksen,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0xFF575757), offset: Offset(-1, -1), blurRadius: 2),
                BoxShadow(color: Color(0xFF000000), offset: Offset(1, 1), blurRadius: 2),
              ],
            ),
            child: const Icon(Icons.arrow_back, color: AppColorsDark.teksOnPrimary, size: 20),
          ),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColorsDark.teksOnPrimary,
          ),
        ),
        titleSpacing: 0,
      ),
      body: Obx(() {
        return Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _profilePhotoCard(),
                  const SizedBox(height: 26),
                  _inputCard("Username", usernameController),
                  const SizedBox(height: 26),
                  _dropdownCard(),
                  const SizedBox(height: 26),
                  _saveButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _profilePhotoCard() {
    return Container(
      width: double.infinity,
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColorsDark.aksen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
          BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              backgroundImage: controller.photoUrl.value.isNotEmpty
                  ? (controller.photoUrl.value.startsWith('http')
                  ? NetworkImage(controller.photoUrl.value)
                  : FileImage(File(controller.photoUrl.value)) as ImageProvider)
                  : const AssetImage('assets/images/gweh.png'),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imageButton("Galeri", () => _pickImage(ImageSource.gallery)),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _inputCard(String label, TextEditingController controller) {
    return Container(
      width: double.infinity,
      height: 142,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColorsDark.aksen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
          BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColorsDark.teksOnPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColorsDark.bg,
                hintText: 'Masukkan $label',
                hintStyle: const TextStyle(color: Colors.black26),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColorsDark.teksOnPrimary, width: 2.0),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColorsDark.teksOnPrimary, width: 2.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: const TextStyle(color: AppColorsDark.teksPrimary, fontSize: 16),
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdownCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColorsDark.aksen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
          BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Trimester", style: TextStyle(color: AppColorsDark.teksOnPrimary, fontSize: 16)),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
            value: selectedTrimester.value,
            dropdownColor: AppColorsDark.bg,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColorsDark.bg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: AppColorsDark.teksOnPrimary),
            items: trimesterOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: AppColorsDark.teksOnPrimary)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) selectedTrimester.value = value;
            },
          )),
          const SizedBox(height: 20),
          const Text("Usia Kehamilan", style: TextStyle(color: AppColorsDark.teksOnPrimary, fontSize: 16)),
          const SizedBox(height: 8),
          Obx(() => DropdownButtonFormField<String>(
            value: selectedUsia.value,
            dropdownColor: AppColorsDark.bg,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColorsDark.bg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            iconEnabledColor: Colors.white,
            style: const TextStyle(color: AppColorsDark.teksOnPrimary),
            items: usiaOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: AppColorsDark.teksOnPrimary)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) selectedUsia.value = value;
            },
          )),
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: 380,
      height: 55,
      child: InkWell(
        onTap: () async {
          await controller.saveUserData(
            usernameController.text,
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColorsDark.aksen,
            boxShadow: const [
              BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
              BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
            ],
          ),
          child: Center(
            child: Text(
              "Simpan Perubahan",
              style: GoogleFonts.dmSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColorsDark.teksOnPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageButton(String label, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsDark.bg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0xFF575757), offset: Offset(-2, -2), blurRadius: 1),
          BoxShadow(color: Color(0xFF000000), offset: Offset(2, 2), blurRadius: 1),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          fixedSize: const Size(130, 40),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: AppColorsDark.teksOnPrimary,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
