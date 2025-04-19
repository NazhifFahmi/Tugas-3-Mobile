import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/home_screen.dart';

class RecommendedSitesWidget extends StatefulWidget {
  @override
  _RecommendedSitesWidgetState createState() => _RecommendedSitesWidgetState();
}

class _RecommendedSitesWidgetState extends State<RecommendedSitesWidget> {
  List<Map<String, dynamic>> _sportsSites = [
    {
      'name': 'ESPN',
      'description':
          'Situs berita olahraga internasional mencakup sepak bola, basket, F1, dan banyak lagi.',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/2/2f/ESPN_wordmark.svg',
      'url': 'https://www.espn.com',
      'isFavorite': false,
    },
    {
      'name': 'Goal.com',
      'description':
          'Portal berita sepak bola yang menyajikan berita, hasil, klasemen, dan statistik.',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/en/thumb/c/cb/Goal.com_logo.svg/1200px-Goal.com_logo.svg.png',
      'url': 'https://www.goal.com',
      'isFavorite': false,
    },
    {
      'name': 'Bleacher Report',
      'description':
          'Menyediakan berita dan analisis mendalam tentang olahraga dan tim favorit.',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/1/1b/Bleacher_Report_logo.svg',
      'url': 'https://bleacherreport.com',
      'isFavorite': false,
    },
    {
      'name': 'Tirto.id - Olahraga',
      'description':
          'Portal berita lokal Indonesia yang juga menyajikan konten olahraga terkini.',
      'imageUrl':
          'https://upload.wikimedia.org/wikipedia/commons/2/29/Tirto.id_logo.svg',
      'url': 'https://tirto.id/q/olahraga-qSW',
      'isFavorite': false,
    },
  ];

  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayedSites =
        _showOnlyFavorites
            ? _sportsSites.where((site) => site['isFavorite']).toList()
            : _sportsSites;

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.blue.shade800),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                  Text(
                    'Situs Rekomendasi',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _showOnlyFavorites
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _showOnlyFavorites ? Colors.red : Colors.grey,
                    ),
                    tooltip:
                        _showOnlyFavorites ? 'Lihat Semua' : 'Lihat Favorit',
                    onPressed: () {
                      setState(() {
                        _showOnlyFavorites = !_showOnlyFavorites;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  displayedSites.isEmpty
                      ? Center(child: Text('Tidak ada situs favorit.'))
                      : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: displayedSites.length,
                        itemBuilder: (context, index) {
                          final site = displayedSites[index];
                          final originalIndex = _sportsSites.indexOf(site);

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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(site['imageUrl']),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                site['name'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                site['isFavorite']
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color:
                                                    site['isFavorite']
                                                        ? Colors.red
                                                        : null,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _sportsSites[originalIndex]['isFavorite'] =
                                                      !_sportsSites[originalIndex]['isFavorite'];
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(site['description']),
                                        SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed:
                                              () => _launchURL(site['url']),
                                          icon: Icon(Icons.open_in_browser),
                                          label: Text(
                                            'Kunjungi Situs',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                              double.infinity,
                                              40,
                                            ),
                                            backgroundColor:
                                                Colors.blue.shade800,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka URL: $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
