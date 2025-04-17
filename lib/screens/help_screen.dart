import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueAccent.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bantuan',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _helpItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _helpItems[index]['title']!,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _helpItems[index]['description']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _helpItems = [
    {
      'title': 'Login',
      'description': 'Masukkan username dan password untuk masuk ke aplikasi.',
    },
    {
      'title': 'Stopwatch',
      'description': 'Fitur penghitung waktu dengan tombol start, pause, dan reset.',
    },
    {
      'title': 'Jenis Bilangan',
      'description': 'Aplikasi untuk menentukan jenis bilangan (prima, desimal, bulat positif/negatif, cacah).',
    },
    {
      'title': 'Tracking LBS',
      'description': 'Fitur untuk melacak lokasi Anda menggunakan TomTom API.',
    },
    {
      'title': 'Konversi Waktu',
      'description': 'Konversi waktu dari tahun ke jam, menit, dan detik.',
    },
    {
      'title': 'Situs Rekomendasi',
      'description': 'Daftar situs yang direkomendasikan dengan gambar dan link.',
    },
    {
      'title': 'Logout',
      'description': 'Keluar dari aplikasi dan menghapus sesi login.',
    },
  ];
}