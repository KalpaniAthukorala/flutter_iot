import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_switch/flutter_switch.dart';

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
  bool light1On = false;
  bool light2On = false;
  bool light3On = false;

  // Track the state of the door lock
  bool doorLockOn = false;

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
      _sendCommand('26', light1On ? 'off' : 'on');
    } else if (lightNumber == 2) {
      setState(() {
        light2On = !light2On;
      });
      _sendCommand('27', light2On ? 'off' : 'on');
    } else if (lightNumber == 3) {
      setState(() {
        light3On = !light3On;
      });
      _sendCommand('14', light3On ? 'off' : 'on');
    }
  }

  void _toggleDoorLock() {
    setState(() {
      doorLockOn = !doorLockOn;
    });
    _sendCommand('12', doorLockOn ? 'low' : 'high');
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
              } else if (_transcription.toLowerCase().contains('door lock')) {
                _toggleDoorLock();
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
        title: const Text('ESP32 Control'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLightSwitch(1),
            _buildLightSwitch(2),
            _buildLightSwitch(3),
            _buildDoorLockSwitch(),
            Text('Transcription: $_transcription'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        tooltip: 'Voice Command',
        child: Icon(Icons.mic),
      ),
    );
  }

  Widget _buildLightSwitch(int lightNumber) {
    String label = lightNumber == 1 ? 'Light 1' : lightNumber == 2 ? 'Light 2' : 'Light 3';
    bool isOn = lightNumber == 1 ? light1On : lightNumber == 2 ? light2On : light3On;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        FlutterSwitch(
          value: isOn,
          onToggle: (value) {
            _toggleLight(lightNumber);
          },
          activeText: 'On',
          inactiveText: 'Off',
          activeColor: Colors.green,
          inactiveColor: Colors.grey,
          toggleColor: Colors.white,
          width: 100.0,
          height: 40.0,
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildDoorLockSwitch() {
    return Column(
      children: [
        Text(
          'Door Lock',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        FlutterSwitch(
          value: doorLockOn,
          onToggle: (value) {
            _toggleDoorLock();
          },
          activeText: 'Locked',
          inactiveText: 'Unlocked',
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          toggleColor: Colors.white,
          width: 100.0,
          height: 40.0,
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}