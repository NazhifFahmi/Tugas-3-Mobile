import 'package:flutter/material.dart';

class MemberListScreen extends StatelessWidget {
  final List<Map<String, String>> members = [
    {
      'name': 'Nazhif Alaudin Fahmi',
      'nim': '123220063',
    },
    {
      'name': 'Seftian Alung Qiu Prakoso',
      'nim': '123220112',
    },
    {
      'name': 'Taufika Retno Wulan',
      'nim': '123220196',
    },
  ];

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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16), // Add horizontal padding
              child: Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: Text(
                  'Daftar Anggota',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: members.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Container(
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
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  members[index]['name']![0],
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    members[index]['name']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'NIM: ${members[index]['nim']}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.person_outline,
                              color: Colors.blueAccent,
                              size: 28,
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
}