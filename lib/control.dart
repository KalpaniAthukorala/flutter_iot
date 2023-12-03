import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final String esp32IpAddress =
      '192.168.1.100'; // Replace with your ESP32's IP address
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _transcription = '';

  // Track the state of each light button
  bool light1On = true;
  bool light2On = true;
  bool light3On = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    // Automatically start listening when the widget is initialized
    _listen();
  }

  Future<void> _sendCommand(String pin, String action) async {
    print('Sending command - Pin: $pin, Action: $action');

    final response = await http.post(
      Uri.parse('http://$esp32IpAddress/control'),
      body: {'pin': pin, 'action': action},
    );

    if (response.statusCode == 200) {
      print('Command sent successfully');
    } else {
      print('Failed to send command. Status code: ${response.statusCode}');
    }
  }

  void _toggleLight(int lightNumber) {
    if (lightNumber == 1) {
      setState(() {
        light1On = !light1On;
      });
      _sendCommand('26', light1On ? 'on' : 'off');
    } else if (lightNumber == 2) {
      setState(() {
        light2On = !light2On;
      });
      _sendCommand('27', light2On ? 'on' : 'off');
    } else if (lightNumber == 3) {
      setState(() {
        light3On = !light3On;
      });
      _sendCommand('14', light3On ? 'on' : 'off');
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('Status: $status');
        },
        onError: (error) {
          print('Error: $error');
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (result) {
            setState(() {
              _transcription = result.recognizedWords;
              print('Transcription: $_transcription');

              // Check for commands
              if (_transcription.toLowerCase().contains('switch one')) {
                _toggleLight(1);
              } else if (_transcription.toLowerCase().contains('switch two')) {
                _toggleLight(2);
              } else if (_transcription
                  .toLowerCase()
                  .contains('switch three')) {
                _toggleLight(3);
              }

              // Continue listening
              _listen();
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });

      _speech.stop();
    }
  }

  @override
  void dispose() {
    // Stop listening when the widget is disposed
    if (_isListening) {
      _speech.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP32 Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _toggleLight(1);
              },
              style: light1On
                  ? ElevatedButton.styleFrom(primary: Colors.green)
                  : null,
              child: Text('Toggle Light 1'),
            ),
            ElevatedButton(
              onPressed: () {
                _toggleLight(2);
              },
              style: light2On
                  ? ElevatedButton.styleFrom(primary: Colors.blue)
                  : null,
              child: Text('Toggle Light 2'),
            ),
            ElevatedButton(
              onPressed: () {
                _toggleLight(3);
              },
              style: light3On
                  ? ElevatedButton.styleFrom(primary: Colors.yellow)
                  : null,
              child: Text('Toggle Light 3'),
            ),
            Text('Transcription: $_transcription'),
          ],
        ),
      ),
    );
  }
}