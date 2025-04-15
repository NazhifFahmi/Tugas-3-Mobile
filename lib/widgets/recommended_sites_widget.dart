import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendedSitesWidget extends StatefulWidget {
  @override
  _RecommendedSitesWidgetState createState() => _RecommendedSitesWidgetState();
}

class _RecommendedSitesWidgetState extends State<RecommendedSitesWidget> {
  List<Map<String, dynamic>> _allSites = [
    {
      'name': 'Flutter Dev',
      'description': 'Dokumentasi dan tutorial untuk Flutter',
      'imageUrl': 'https://storage.googleapis.com/cms-storage-bucket/6e19fee6b47b36ca613f.png',
      'url': 'https://flutter.dev',
      'isFavorite': false,
    },
    {
      'name': 'Dart Dev',
      'description': 'Bahasa pemrograman Dart',
      'imageUrl': 'https://dart.dev/assets/img/shared/dart/logo+text/horizontal/white.svg',
      'url': 'https://dart.dev',
      'isFavorite': false,
    },
    {
      'name': 'TomTom Developer',
      'description': 'API dan SDK untuk layanan lokasi',
      'imageUrl': 'https://developer.tomtom.com/assets/tomtom-logo-black.svg',
      'url': 'https://developer.tomtom.com',
      'isFavorite': false,
    },
    {
      'name': 'GitHub',
      'description': 'Platform hosting dan kolaborasi kode',
      'imageUrl': 'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
      'url': 'https://github.com',
      'isFavorite': false,
    },
    {
      'name': 'Stack Overflow',
      'description': 'Komunitas Q&A untuk programmer',
      'imageUrl': 'https://cdn.sstatic.net/Sites/stackoverflow/Img/logo.svg',
      'url': 'https://stackoverflow.com',
      'isFavorite': false,
    },
  ];

  List<Map<String, dynamic>> _favorites = [];
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sitesToShow = _showFavoritesOnly ? _favorites : _allSites;

    return Scaffold(
      appBar: AppBar(
        title: Text('Situs Rekomendasi'),
        actions: [
          IconButton(
            icon: Icon(_showFavoritesOnly ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _showFavoritesOnly = !_showFavoritesOnly;
              });
            },
          ),
        ],
      ),
      body: sitesToShow.isEmpty
          ? Center(
              child: Text(
                _showFavoritesOnly
                    ? 'Tidak ada situs favorit'
                    : 'Tidak ada situs rekomendasi',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: sitesToShow.length,
              itemBuilder: (context, index) {
                final site = sitesToShow[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image placeholder
                      Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Text(
                            '${site['name']} Image',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  site['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    site['isFavorite']
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: site['isFavorite'] ? Colors.red : null,
                                  ),
                                  onPressed: () => _toggleFavorite(site),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(site['description']),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _launchURL(site['url']),
                              icon: Icon(Icons.open_in_new),
                              label: Text('Kunjungi Situs'),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 40),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> site) {
    setState(() {
      site['isFavorite'] = !site['isFavorite'];
      
      if (site['isFavorite']) {
        // Tambahkan ke favorit jika belum ada
        if (!_favorites.contains(site)) {
          _favorites.add(site);
        }
      } else {
        // Hapus dari favorit
        _favorites.removeWhere((s) => s['url'] == site['url']);
      }
    });
  }

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak dapat membuka URL: $url')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}