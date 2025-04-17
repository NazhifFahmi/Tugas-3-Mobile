import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import '../widgets/stopwatch_widget.dart';
import '../widgets/number_types_widget.dart';
import '../widgets/location_tracking_widget.dart';
import '../widgets/time_conversion_widget.dart';
import '../widgets/recommended_sites_widget.dart';
import 'member_list_screen.dart';
import 'help_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadUsername();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Main',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade600,
              child: Text(
                _username.isNotEmpty ? _username[0].toUpperCase() : 'P',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: _selectedIndex == 0
            ? _buildHomeContent()
            : _selectedIndex == 1
                ? MemberListScreen()
                : HelpScreen(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Halo, $_username',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Apa yang ingin Anda lakukan hari ini?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            _buildMenuCard(
              'Stopwatch',
              Icons.timer,
              Colors.blue.shade700,
              () => _navigateToScreen(StopwatchWidget()),
            ),
            _buildMenuCard(
              'Jenis Bilangan',
              Icons.calculate,
              Colors.green.shade700,
              () => _navigateToScreen(NumberTypesWidget()),
            ),
            _buildMenuCard(
              'Tracking Lokasi',
              Icons.location_on,
              Colors.orange.shade700,
              () => _navigateToScreen(LocationTrackingWidget()),
            ),
            _buildMenuCard(
              'Konversi Waktu',
              Icons.access_time,
              Colors.purple.shade700,
              () => _navigateToScreen(TimeConversionWidget()),
            ),
            _buildMenuCard(
              'Situs Rekomendasi',
              Icons.web,
              Colors.red.shade700,
              () => _navigateToScreen(RecommendedSitesWidget()),
            ),
            SizedBox(height: 24),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue.shade800,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          elevation: 10,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'Anggota',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              activeIcon: Icon(Icons.help),
              label: 'Bantuan',
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}