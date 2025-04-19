import 'package:flutter/material.dart';
import '../screens/home_screen.dart';

class TimeConversionWidget extends StatefulWidget {
  @override
  _TimeConversionWidgetState createState() => _TimeConversionWidgetState();
}

class _TimeConversionWidgetState extends State<TimeConversionWidget> {
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  
  // Konstanta konversi
  final double _daysInYear = 365.0; // Using 365 for simplicity (non-leap year)
  final double _hoursInDay = 24.0;
  final double _minutesInHour = 60.0;
  final double _secondsInMinute = 60.0;

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
                    'Konversi Tahun ke Satuan Waktu',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Masukkan Jumlah Tahun',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Konversi akan menampilkan dalam hari, jam, menit, dan detik',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildYearInputField(),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _convertYears,
                      child: Text(
                        'Konversi',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildResultCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearInputField() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _yearController,
              decoration: InputDecoration(
                labelText: 'Tahun (contoh: 1)',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _yearController.clear();
                    _clearResultFields();
                  },
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hasil Konversi:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Column(
              children: [
                _buildResultItem('Hari', _dayController.text.isEmpty ? '-' : _dayController.text),
                _buildResultItem('Jam', _hourController.text.isEmpty ? '-' : _hourController.text),
                _buildResultItem('Menit', _minuteController.text.isEmpty ? '-' : _minuteController.text),
                _buildResultItem('Detik', _secondController.text.isEmpty ? '-' : _secondController.text),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _clearResultFields() {
    setState(() {
      _dayController.clear();
      _hourController.clear();
      _minuteController.clear();
      _secondController.clear();
    });
  }

  void _convertYears() {
    try {
      if (_yearController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Masukkan jumlah tahun terlebih dahulu')),
        );
        return;
      }
      
      double years = double.parse(_yearController.text);
      
      // Calculate all values directly
      double days = years * _daysInYear;
      double hours = days * _hoursInDay;
      double minutes = hours * _minutesInHour;
      double seconds = minutes * _secondsInMinute;
      
      // Format the numbers
      String formattedDays = days.toStringAsFixed(days.truncateToDouble() == days ? 0 : 2);
      String formattedHours = hours.toStringAsFixed(hours.truncateToDouble() == hours ? 0 : 2);
      String formattedMinutes = minutes.toStringAsFixed(minutes.truncateToDouble() == minutes ? 0 : 2);
      String formattedSeconds;
      
      // Format seconds in scientific notation if too large
      if (seconds >= 1e6) {
        formattedSeconds = seconds.toStringAsExponential(2).replaceAll('e+', 'e+');
      } else {
        formattedSeconds = seconds.toStringAsFixed(seconds.truncateToDouble() == seconds ? 0 : 2);
      }
      
      // Update fields
      setState(() {
        _dayController.text = formattedDays;
        _hourController.text = formattedHours;
        _minuteController.text = formattedMinutes;
        _secondController.text = formattedSeconds;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Input tidak valid: $e')),
      );
    }
  }
}