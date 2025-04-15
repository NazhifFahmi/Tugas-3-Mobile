import 'package:flutter/material.dart';

class MemberListScreen extends StatelessWidget {
  final List<Map<String, String>> members = [
    {
      'name': 'Nazhif Alaudin Fahmi',
      'nim': '123220063',
    },
    {
      'name': 'Septian Alung',
      'nim': '123220',
    },
    {
      'name': 'Taufika Retno Wulan',
      'nim': '123220',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Anggota'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(members[index]['name']![0]),
              ),
              title: Text(members[index]['name']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NIM: ${members[index]['nim']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}