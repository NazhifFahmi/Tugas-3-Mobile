import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bantuan'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildHelpItem(
            'Login',
            'Masukkan username dan password untuk masuk ke aplikasi.',
          ),
          _buildHelpItem(
            'Stopwatch',
            'Fitur penghitung waktu dengan tombol start, pause, dan reset.',
          ),
          _buildHelpItem(
            'Jenis Bilangan',
            'Aplikasi untuk menentukan jenis bilangan (prima, desimal, bulat positif/negatif, cacah).',
          ),
          _buildHelpItem(
            'Tracking LBS',
            'Fitur untuk melacak lokasi Anda menggunakan TomTom API.',
          ),
          _buildHelpItem(
            'Konversi Waktu',
            'Konversi waktu dari tahun ke jam, menit, dan detik.',
          ),
          _buildHelpItem(
            'Situs Rekomendasi',
            'Daftar situs yang direkomendasikan dengan gambar dan link.',
          ),
          _buildHelpItem(
            'Logout',
            'Keluar dari aplikasi dan menghapus sesi login.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}