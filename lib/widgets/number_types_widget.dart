import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart'; 
import 'dart:math' as math; 
import '../screens/home_screen.dart';

class NumberTypesWidget extends StatefulWidget {
  const NumberTypesWidget({super.key});

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
  
  bool _showLargeNumberWarning = false; 
  bool _isProcessing = false;          

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
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  Text(
                    'Jenis Bilangan',
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
                          onPressed: _resetAll,
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
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
                    if (_showLargeNumberWarning)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Catatan: Bilangan sangat besar, pemeriksaan bilangan prima terbatas',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    SizedBox(height: 24),
                    Text(
                      'Hasil:',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ..._numberTypes.entries.map(_buildResultItem),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(MapEntry<String, bool> entry) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          entry.value ? Icons.check_circle : Icons.cancel,
          color: entry.value ? Colors.green : Colors.red,
        ),
        title: Text(entry.key),
      ),
    );
  }

  void _resetAll() {
    setState(() {
      _inputController.clear();
      _numberTypes.updateAll((_, __) => false);
      _showLargeNumberWarning = false;
      _isProcessing = false;
    });
  }

  Future<void> _checkNumberType() async {
    final input = _inputController.text.trim().replaceAll(',', '.');
    
    setState(() {
      _showLargeNumberWarning = false;
      _numberTypes.updateAll((_, __) => false);
      _isProcessing = true;
    });

    if (input.isEmpty) {
      _showError('Masukkan bilangan terlebih dahulu');
      setState(() => _isProcessing = false);
      return;
    }

    if (!RegExp(r'^-?\d*\.?\d+$').hasMatch(input)) {
      _showError('Format bilangan tidak valid');
      setState(() => _isProcessing = false);
      return;
    }

    try {
      final hasDecimalPoint = input.contains('.');
      final isNegative = input.startsWith('-');
      final isZero = input == '0' || input == '0.0';
      
      Decimal? number;
      bool isVeryLarge = false;
      
      try {
        number = Decimal.parse(input);
      } catch (e) {
        isVeryLarge = true;
        setState(() => _showLargeNumberWarning = true);
      }

      bool isDecimal = false;
      if (number != null) {
        isDecimal = (number % Decimal.one) != Decimal.zero;
      } else {
        isDecimal = hasDecimalPoint;
      }

      setState(() {
        _numberTypes = {
          'Prima': !isVeryLarge && number != null && _isPrime(number),
          'Desimal': isDecimal,
          'Bulat Positif': !isNegative && !isDecimal && !isZero,
          'Bulat Negatif': isNegative && !isDecimal,
          'Cacah': !isNegative && !isDecimal,
        };
        _isProcessing = false;
      });
    } catch (e) {
      _showError('Terjadi kesalahan dalam memproses bilangan');
      setState(() => _isProcessing = false);
    }
  }

  bool _isPrime(Decimal number) {
    if (number <= Decimal.one || !number.isInteger) return false;
    if (number == Decimal.fromInt(2)) return true;
    if (number % Decimal.fromInt(2) == Decimal.zero) return false;

    final bigIntValue = number.toBigInt();
    final sqrtValue = _sqrtBigInt(bigIntValue);
    var i = Decimal.fromInt(3);
    final max = Decimal.fromBigInt(sqrtValue);
    
    while (i <= max) {
      if (number % i == Decimal.zero) return false;
      i += Decimal.fromInt(2);
    }
    return true;
  }

  BigInt _sqrtBigInt(BigInt n) {
    if (n < BigInt.zero) throw ArgumentError('Negative numbers not supported');
    if (n < BigInt.two) return n;
    
    BigInt a = BigInt.one;
    BigInt b = n >> 1;
    while (b >= a) {
      final mid = (a + b) >> 1;
      final square = mid * mid;
      if (square == n) return mid;
      if (square > n) {
        b = mid - BigInt.one;
      } else {
        a = mid + BigInt.one;
      }
    }
    return a - BigInt.one;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}