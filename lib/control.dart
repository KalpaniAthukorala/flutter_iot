import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_switch/flutter_switch.dart';

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final String esp32IpAddress =
      '192.168.1.100'; // Replace with your ESP32's IP address

  String _transcription = '';

  // Track the state of each light button
  bool light1On = false;
  bool light2On = false;
  bool light3On = false;
  bool light4On = false;

  // Track the state of the door lock
  bool doorLockOn = false;

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
    String pin;
    switch (lightNumber) {
      case 1:
        pin = '12';
        break;
      case 2:
        pin = '14';
        break;
      case 3:
        pin = '26';
        break;
      case 4:
        pin = '27';
        break;
      default:
        return;
    }

    setState(() {
      if (lightNumber == 1) {
        light1On = !light1On;
      } else if (lightNumber == 2) {
        light2On = !light2On;
      } else if (lightNumber == 3) {
        light3On = !light3On;
      } else if (lightNumber == 4) {
        light4On = !light4On;
      }
    });

    _sendCommand(pin, light1On ? 'off' : 'on');
  }

  void _toggleDoorLock() {
    setState(() {
      doorLockOn = !doorLockOn;
    });
    // _sendCommand('19', doorLockOn ? 'off' : 'on');
    if (doorLockOn) {
      //doorLockOn = true;
      _sendCommand('19', doorLockOn ? 'off' : 'on');
      print("command ex1");
      Future.delayed(const Duration(seconds: 5), () {
        _sendCommand('19', 'on');
        print("command ex2");
      });
    }
    if (!doorLockOn) {
      //doorLockOn = false;
      _sendCommand('18', doorLockOn ? 'on' : 'off');
      Future.delayed(const Duration(seconds: 5), () {
        _sendCommand('18', 'on');
      });
    }
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
            _buildLightSwitch(4),
            _buildDoorLockSwitch(),
            Text('Transcription: $_transcription'),
          ],
        ),
      ),
    );
  }

  Widget _buildLightSwitch(int lightNumber) {
    String label = lightNumber == 1
        ? 'Light 1'
        : lightNumber == 2
            ? 'Light 2'
            : lightNumber == 3
                ? 'Light 3'
                : 'Light 4';
    bool isOn = lightNumber == 1
        ? light1On
        : lightNumber == 2
            ? light2On
            : lightNumber == 3
                ? light3On
                : light4On;

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
