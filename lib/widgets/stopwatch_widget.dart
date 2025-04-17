import 'package:flutter/material.dart';
import 'dart:async';
import '../screens/home_screen.dart';

class StopwatchWidget extends StatefulWidget {
  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsedTime = '00:00:00';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        _updateTime();
      });
    }
  }

  void _stopTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      setState(() {});
    }
  }

  void _resetTimer() {
    _stopwatch.reset();
    _updateTime();
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        final milliseconds = _stopwatch.elapsedMilliseconds;
        final hours = (milliseconds / (1000 * 60 * 60)).floor();
        final minutes = ((milliseconds / (1000 * 60)) % 60).floor();
        final seconds = ((milliseconds / 1000) % 60).floor();
        final milliStr = ((milliseconds % 1000) / 10).floor().toString().padLeft(2, '0');
        
        _elapsedTime = 
            '${hours.toString().padLeft(2, '0')}:'
            '${minutes.toString().padLeft(2, '0')}:'
            '${seconds.toString().padLeft(2, '0')}.$milliStr';
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
                    'Stopwatch',
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _elapsedTime,
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _startTimer,
                          child: Text(
                            'Start',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _stopTimer,
                          child: Text(
                            'Stop',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _resetTimer,
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}