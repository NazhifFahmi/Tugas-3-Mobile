import 'package:flutter/material.dart';
import 'dart:math';
import '../screens/home_screen.dart';

class NumberTypesWidget extends StatefulWidget {
  @override
  _NumberTypesWidgetState createState() => _NumberTypesWidgetState();
}

class _NumberTypesWidgetState extends State<NumberTypesWidget> {
  final TextEditingController _inputController = TextEditingController();
  Map<String, bool> _numberTypes = {
    'Prima': false,
    'Desimal': false,
    'Bulat Positif': false,
    'Bulat Negatif': false,
    'Cacah': false,
  };

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
                    'Jenis Bilangan',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        labelText: 'Masukkan Bilangan',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _inputController.clear();
                            _resetResults();
                          },
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _checkNumberType,
                      child: Text(
                        'Periksa Jenis Bilangan',
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
                    SizedBox(height: 24),
                    Text(
                      'Hasil:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ..._numberTypes.entries.map((entry) => _buildResultItem(entry.key, entry.value)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String type, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
          ),
          SizedBox(width: 8),
          Text(
            type,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _resetResults() {
    setState(() {
      _numberTypes.updateAll((key, value) => false);
    });
  }

  void _checkNumberType() {
    String input = _inputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan bilangan terlebih dahulu')),
      );
      return;
    }

    try {
      // Coba parse sebagai double untuk memeriksa jika input adalah bilangan valid
      double number = double.parse(input);
      
      bool isPrime = _isPrime(number);
      bool isDecimal = number % 1 != 0;
      bool isPositiveInteger = number > 0 && number % 1 == 0;
      bool isNegativeInteger = number < 0 && number % 1 == 0;
      bool isWhole = number >= 0 && number % 1 == 0;

      setState(() {
        _numberTypes = {
          'Prima': isPrime,
          'Desimal': isDecimal,
          'Bulat Positif': isPositiveInteger,
          'Bulat Negatif': isNegativeInteger,
          'Cacah': isWhole,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Input bukan bilangan yang valid')),
      );
    }
  }

  bool _isPrime(double number) {
    // Bilangan prima harus berupa bilangan bulat positif lebih dari 1
    if (number <= 1 || number % 1 != 0) return false;
    
    int n = number.toInt();
    for (int i = 2; i <= sqrt(n); i++) {
      if (n % i == 0) return false;
    }
    return true;
  }
}