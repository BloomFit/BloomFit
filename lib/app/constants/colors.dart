import 'dart:ui';

// Mode Terang (Light Mode)
class AppColorsLight {
  // Warna Pink yang lebih lembut
  static const Color primary = Color(0xFFD81B60);    // Pink lebih gelap untuk elemen utama
  static const Color aksen = Color(0xFFEC407A);      // Pink menengah untuk aksen
  static const Color third = Color(0xFFF48FB1);      // Pink lebih lembut
  static const Color fourth = Color(0xFFFCE4EC);     // Pink sangat lembut untuk area luas

  // Background dengan warna yang lebih nyaman
  static const Color bg = Color(0xFFFAFAFA);

  // Warna teks yang nyaman dibaca
  static const Color teksPrimary = Color(0xFF212121); // Hampir hitam untuk teks utama
  static const Color teksSecondary = Color(0xFF757575); // Abu-abu untuk teks sekunder
  static const Color teksOnPrimary = Color(0xFFFFFFFF); // Putih untuk teks di atas warna primary

  // Warna card yang lebih nyaman
  static const Color cardPrimary = Color(0xFFFFFFFF); // Putih untuk kartu utama
  static const Color cardSecondary = Color(0xFFF5F5F5); // Abu-abu sangat terang untuk kartu sekunder
}

// Mode Gelap (Dark Mode)
class AppColorsDark {
  // Warna Pink yang disesuaikan untuk mode gelap
  static const Color primary = Color(0xFFD81B60);    // Tetap mempertahankan pink yang kuat
  static const Color aksen = Color(0xFFEC407A);      // Pink menengah
  static const Color third = Color(0xFFF48FB1);      // Pink lebih lembut
  static const Color fourth = Color(0xFFFCE4EC);     // Pink yang sangat gelap

  // Background gelap yang nyaman untuk mata
  static const Color bg = Color(0xFF121212);         // Gelap tetapi tidak hitam pekat

  // Warna teks untuk mode gelap
  static const Color teksPrimary = Color(0xFFEEEEEE); // Putih sedikit abu-abu untuk teks utama
  static const Color teksSecondary = Color(0xFFB0B0B0); // Abu-abu terang untuk teks sekunder
  static const Color teksOnPrimary = Color(0xFFFFFFFF); // Putih untuk teks di atas warna primary

  // Warna card untuk mode gelap
  static const Color cardPrimary = Color(0xFF1E1E1E); // Abu-abu sangat gelap untuk kartu
  static const Color cardSecondary = Color(0xFF2C2C2C); // Abu-abu gelap untuk kartu sekunder
}