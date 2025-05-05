import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_app/app/routes/app_pages.dart';
import '../../../constants/colors.dart';
import '../controllers/edit_profile_page_controller.dart';

class EditProfilePageView extends GetView<EditProfilePageController> {
  const EditProfilePageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColorsDark.fourth,
      appBar: AppBar(
        backgroundColor: AppColorsDark.fourth,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColorsDark.teksThird),
          iconSize: 16,
          onPressed: () => Get.offAllNamed(Routes.PROFILE_PAGE),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              color: AppColorsDark.teksThird,
            fontSize: 16
          ),
        ),
        titleSpacing: 0,
      ),
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 220,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColorsDark.third,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF575757),
                      offset: Offset(-2, -2),
                      blurRadius: 1,
                    ),
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(2, 2),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/gweh.png'),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColorsDark.bg,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF575757),
                                  offset: Offset(-2, -2),
                                  blurRadius: 1,
                                ),
                                BoxShadow(
                                  color: Color(0xFF000000),
                                  offset: Offset(2, 2),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                fixedSize: const Size(130, 40),
                              ),
                              onPressed: () {
                              },
                              child: const Text(
                                'Galeri',
                                style: TextStyle(
                                  color: AppColorsDark.teksThird,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: AppColorsDark.bg,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF575757),
                                  offset: Offset(-2, -2),
                                  blurRadius: 1,
                                ),
                                BoxShadow(
                                  color: Color(0xFF000000),
                                  offset: Offset(2, 2),
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                fixedSize: const Size(130, 40),
                              ),
                              onPressed: () {
                              },
                              child: const Text(
                                'Kamera',
                                style: TextStyle(
                                  color: AppColorsDark.teksThird,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // Card 2
              Container(
                width: double.infinity,
                height: 142,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColorsDark.third,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF575757),
                      offset: Offset(-2, -2),
                      blurRadius: 1,
                    ),
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(2, 2),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Teks Username
                      Text(
                        'Username',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColorsDark.teksThird,
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColorsDark.bg,
                          hintText: 'yaseruuuu',
                          hintStyle: TextStyle(color: Colors.black),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColorsDark.teksThird,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColorsDark.teksThird,
                              width: 2.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        style: TextStyle(
                          color: AppColorsDark.teksPrimary,
                          fontSize: 16,
                        ),
                        onChanged: (value) {

                        },
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 26),

              // Card 3
              Container(
                width: double.infinity,
                height: 280,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColorsDark.third,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF575757),
                      offset: Offset(-2, -2),
                      blurRadius: 1,
                    ),
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(2, 2),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 360,
                          height: 45,
                          child: InkWell(
                            onTap: (){

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColorsDark.bg,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFF575757),
                                    offset: Offset(-2, -2),
                                    blurRadius: 1,
                                  ),
                                  BoxShadow(
                                    color: Color(0xFF000000),
                                    offset: Offset(2, 2),
                                    blurRadius: 1,
                                  ),
                                ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              AppColorsDark.teksThird,
                                              BlendMode.srcIn,
                                            ),
                                            // child: Image.asset('assets/icons/account.png'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Trimester 1',
                                        style: TextStyle(
                                          color: AppColorsDark.teksThird,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                          width: 360,
                          height: 45,
                          child: InkWell(
                            onTap: (){

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColorsDark.bg,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFF575757),
                                      offset: Offset(-2, -2),
                                      blurRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: Color(0xFF000000),
                                      offset: Offset(2, 2),
                                      blurRadius: 1,
                                    ),
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              AppColorsDark.teksThird,
                                              BlendMode.srcIn,
                                            ),
                                            // child: Image.asset('assets/icons/account.png'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '3 Minggu',
                                        style: TextStyle(
                                          color: AppColorsDark.teksThird,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                          width: 360,
                          height: 45,
                          child: InkWell(
                            onTap: (){

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColorsDark.bg,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFF575757),
                                      offset: Offset(-2, -2),
                                      blurRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: Color(0xFF000000),
                                      offset: Offset(2, 2),
                                      blurRadius: 1,
                                    ),
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              AppColorsDark.teksThird,
                                              BlendMode.srcIn,
                                            ),
                                            // child: Image.asset('assets/icons/account.png'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Sehat',
                                        style: TextStyle(
                                          color: AppColorsDark.teksThird,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                          width: 360,
                          height: 45,
                          child: InkWell(
                            onTap: (){

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColorsDark.bg,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xFF575757),
                                      offset: Offset(-2, -2),
                                      blurRadius: 1,
                                    ),
                                    BoxShadow(
                                      color: Color(0xFF000000),
                                      offset: Offset(2, 2),
                                      blurRadius: 1,
                                    ),
                                  ]
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 20),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          child: ColorFiltered(
                                            colorFilter: const ColorFilter.mode(
                                              AppColorsDark.teksThird,
                                              BlendMode.srcIn,
                                            ),
                                            // child: Image.asset('assets/icons/account.png'),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        '9 Jul 2006',
                                        style: TextStyle(
                                          color: AppColorsDark.teksThird,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 26),

              SizedBox(
                  width: 380,
                  height: 55,
                  child: InkWell(
                    onTap: (){

                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColorsDark.third,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF575757),
                              offset: Offset(-2, -2),
                              blurRadius: 1,
                            ),
                            BoxShadow(
                              color: Color(0xFF000000),
                              offset: Offset(2, 2),
                              blurRadius: 1,
                            ),
                          ]
                      ),
                      child: Center(
                        child: Text(
                          "Simpan Perubahan",
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColorsDark.teksThird,

                          ),
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),

    );
  }
}
