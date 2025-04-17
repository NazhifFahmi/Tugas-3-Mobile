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
  final double _secondsInMinute = 60;
  final double _secondsInHour = 60 * 60;
  final double _secondsInDay = 24 * 60 * 60;
  final double _secondsInYear = 365.25 * 24 * 60 * 60; // Menggunakan 365.25 untuk akurasi tahun kabisat
  
  bool _isConvertingToYears = true; // Mode konversi: true = ke tahun, false = dari tahun

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
                    'Konversi Waktu',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Mode Konversi',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  value: _isConvertingToYears,
                                  onChanged: (value) {
                                    setState(() {
                                      _isConvertingToYears = value;
                                      _clearAllFields();
                                    });
                                  },
                                  activeTrackColor: Colors.blue.shade200,
                                  activeColor: Colors.blue,
                                ),
                              ],
                            ),
                            Text(
                              _isConvertingToYears
                                  ? 'Konversi dari hari/jam/menit/detik ke tahun'
                                  : 'Konversi dari tahun ke hari/jam/menit/detik',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_isConvertingToYears) 
                      _buildMultiInputFields()
                    else 
                      _buildSingleInputField(),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _convert,
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

  Widget _buildSingleInputField() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan Tahun',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(
                labelText: 'Tahun (bisa desimal)',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _yearController.clear(),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiInputFields() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Masukkan Satuan Waktu',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildTimeInputField('Hari', _dayController),
            SizedBox(height: 8),
            _buildTimeInputField('Jam', _hourController),
            SizedBox(height: 8),
            _buildTimeInputField('Menit', _minuteController),
            SizedBox(height: 8),
            _buildTimeInputField('Detik', _secondController),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () => controller.clear(),
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
            if (_isConvertingToYears)
              _buildResultItem('Total Tahun', _yearController.text.isEmpty ? '0' : _formatNumber(double.parse(_yearController.text)))
            else 
              Column(
                children: [
                  _buildResultItem('Hari', _dayController.text.isEmpty ? '0' : _dayController.text),
                  _buildResultItem('Jam', _hourController.text.isEmpty ? '0' : _hourController.text),
                  _buildResultItem('Menit', _minuteController.text.isEmpty ? '0' : _minuteController.text),
                  _buildResultItem('Detik', _secondController.text.isEmpty ? '0' : _secondController.text),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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

  String _formatNumber(double value) {
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 6);
  }

  void _clearAllFields() {
    _yearController.clear();
    _dayController.clear();
    _hourController.clear();
    _minuteController.clear();
    _secondController.clear();
  }

  void _convert() {
    if (_isConvertingToYears) {
      _convertToYears();
    } else {
      _convertFromYears();
    }
  }

  void _convertToYears() {
    try {
      double days = double.tryParse(_dayController.text) ?? 0;
      double hours = double.tryParse(_hourController.text) ?? 0;
      double minutes = double.tryParse(_minuteController.text) ?? 0;
      double seconds = double.tryParse(_secondController.text) ?? 0;
      
      // Konversi semua ke detik
      double totalSeconds = 
          days * _secondsInDay +
          hours * _secondsInHour +
          minutes * _secondsInMinute +
          seconds;
      
      // Konversi detik ke tahun
      double totalYears = totalSeconds / _secondsInYear;
      
      // Update field tahun
      setState(() {
        _yearController.text = _formatNumber(totalYears);
        _dayController.clear();
        _hourController.clear();
        _minuteController.clear();
        _secondController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error konversi: $e')),
      );
    }
  }

  void _convertFromYears() {
    try {
      // Ambil input tahun
      if (_yearController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Masukkan jumlah tahun terlebih dahulu')),
        );
        return;
      }
      
      double years = double.parse(_yearController.text);
      
      // Konversi tahun ke detik
      double totalSeconds = years * _secondsInYear;
      
      // Hitung hari
      double totalDays = totalSeconds / _secondsInDay;
      int days = totalDays.floor();
      double remainingSeconds = totalSeconds - (days * _secondsInDay);
      
      // Hitung jam
      double totalHours = remainingSeconds / _secondsInHour;
      int hours = totalHours.floor();
      remainingSeconds -= hours * _secondsInHour;
      
      // Hitung menit
      double totalMinutes = remainingSeconds / _secondsInMinute;
      int minutes = totalMinutes.floor();
      remainingSeconds -= minutes * _secondsInMinute;
      
      // Hitung detik (dibulatkan untuk menghindari floating point error)
      int seconds = remainingSeconds.round();
      
      // Handle overflow (jika detik dibulatkan menjadi 60)
      if (seconds >= 60) {
        seconds -= 60;
        minutes += 1;
      }
      if (minutes >= 60) {
        minutes -= 60;
        hours += 1;
      }
      if (hours >= 24) {
        hours -= 24;
        days += 1;
      }
      
      // Update fields
      setState(() {
        _yearController.clear();
        _dayController.text = days.toString();
        _hourController.text = hours.toString();
        _minuteController.text = minutes.toString();
        _secondController.text = seconds.toString();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Input tidak valid: $e')),
      );
    }
  }
}