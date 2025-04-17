import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../screens/home_screen.dart';

class LocationTrackingWidget extends StatefulWidget {
  @override
  _LocationTrackingWidgetState createState() => _LocationTrackingWidgetState();
}

class _LocationTrackingWidgetState extends State<LocationTrackingWidget> {
  Position? _currentPosition;
  String _address = 'Mencari lokasi...';
  bool _isLoading = true;
  final String _tomtomApiKey = 'zyfvME2xfvZxL53tDFcrELrbn8halTwu'; // Ganti dengan API key TomTom Anda
  
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _address = 'Akses lokasi ditolak';
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _address = 'Akses lokasi ditolak secara permanen';
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = position;
      });

      // Get address using TomTom API
      await _getAddressFromLatLng();
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _address = 'Error: $e';
      });
    }
  }

  Future<void> _getAddressFromLatLng() async {
    if (_currentPosition == null) return;
    
    try {
      final url = 'https://api.tomtom.com/search/2/reverseGeocode/${_currentPosition!.latitude},${_currentPosition!.longitude}.json?key=$_tomtomApiKey';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['addresses'] != null && data['addresses'].isNotEmpty) {
          final address = data['addresses'][0]['address'];
          final formattedAddress = [
            address['streetNumber'],
            address['streetName'],
            address['municipalitySubdivision'],
            address['municipality'],
            address['countrySubdivision'],
            address['country']
          ].where((element) => element != null).join(', ');
          
          setState(() {
            _address = formattedAddress;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _address = 'Tidak dapat menemukan alamat';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Error: $e';
        _isLoading = false;
      });
    }
  }

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
                    'Tracking LBS',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48), // Placeholder for alignment
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _currentPosition == null
                              ? Center(child: Text('Lokasi tidak tersedia'))
                              : FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    center: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                    zoom: 15.0,
                                  ),
                                  children: [
                                    TileLayer(
                                      urlTemplate: 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=$_tomtomApiKey',
                                      additionalOptions: {'apiKey': _tomtomApiKey},
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                                          width: 40,
                                          height: 40,
                                          builder: (context) => Icon(
                                            Icons.location_on,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Informasi Lokasi:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Alamat:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text(_address),
                                        SizedBox(height: 8),
                                        if (_currentPosition != null) ...[
                                          Text('Koordinat:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text('Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}'),
                                          Text('Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}'),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _getCurrentLocation();
                                  },
                                  icon: Icon(Icons.refresh),
                                  label: Text(
                                    'Perbarui Lokasi',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    backgroundColor: Colors.blue.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
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
  }
}