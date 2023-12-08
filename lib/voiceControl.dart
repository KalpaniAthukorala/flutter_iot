import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:flutter_switch/flutter_switch.dart';
import 'api/speech.dart';
import 'util.dart';
import 'package:substring_highlight/substring_highlight.dart';

class VoiceControl extends StatefulWidget {
  @override
  _VoiceControlState createState() => _VoiceControlState();
}

class _VoiceControlState extends State<VoiceControl> {
  bool isListening = false;
  String text = 'I can hear you';
  // Track the state of each light button

  bool light1On = false;
  bool light2On = false;
  bool light3On = false;
  bool light4On = false;

  // Track the state of the door lock
  bool doorLockOn = false;

  final String esp32IpAddress = '192.168.1.100';

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

  void _toggleLight(String lightNumber) {
    if (lightNumber == Command.switchOne) {
      light1On = !light1On;
      _sendCommand('12', light1On ? 'off' : 'on');
    } else if (lightNumber == Command.switchTwo) {
      light2On = !light2On;
      _sendCommand('14', light2On ? 'off' : 'on');
    } else if (lightNumber == Command.switchThree) {
      light3On = !light3On;
      _sendCommand('26', light3On ? 'off' : 'on');
    }else if (lightNumber == Command.switchFour) {
      light4On = !light4On;
      _sendCommand('27', light4On ? 'off' : 'on');
    } else if (lightNumber == Command.doorlock) {
    
      if (!doorLockOn) {
        doorLockOn = true;
        _sendCommand('19', doorLockOn ? 'low' : 'high');
        print("command ex1");
        Future.delayed(const Duration(seconds: 5), () {
          _sendCommand('19', 'low');
          print("command ex2");
        });
      }
      
    } else if (lightNumber == Command.doorUnlock) {
      
      if (doorLockOn) {
         doorLockOn = false;
        _sendCommand('18', doorLockOn ? 'high' : 'low');
        Future.delayed(const Duration(seconds: 5), () {
          _sendCommand('18', 'low');
        });
      }
      
    }  
    
    else if (lightNumber == Command.allLightOn) {
      // Future.delayed(const Duration(seconds: 1),(){   dan
      if (!light1On) {
        light1On = true;
        _sendCommand('12', light1On ? 'off' : 'on');
      }
      //  });
      // Future.delayed(const Duration(seconds: 1),(){
      if (!light2On) {
        light2On = true;
        _sendCommand('14', light2On ? 'off' : 'on');
      }
      // });
      // Future.delayed(const Duration(seconds: 1),(){
      if (!light3On) {
        light3On = true;
        _sendCommand('26', light3On ? 'off' : 'on');
      }

      if (!light4On) {
        light4On = true;
        _sendCommand('27', light4On ? 'off' : 'on');
      }
      // });
    } else if (lightNumber == Command.allLightOff) {
      if (light1On) {
        light1On = false;
        _sendCommand('12', light1On ? 'off' : 'on');
      }

      if (light2On) {
        light2On = false;
        _sendCommand('14', light2On ? 'off' : 'on');
      }

      if (light3On) {
        light3On = false;
        _sendCommand('26', light3On ? 'off' : 'on');
      }

      if (light4On) {
        light4On = false;
        _sendCommand('27', light4On ? 'off' : 'on');
      }
    }
    
    //  print(lightNumber + " " + Command.allLightOn);
  }

  @override
  void initState() {
    super.initState();
  }

  Future toggleRecoding() => SpeachApi.toggleRecoding(
        onResult: (text) => setState(() => this.text = text),
        onListning: (isListening) {
          setState(() {
            this.isListening = isListening;
            print("kkkkkkkkk");
            if (!isListening) {
              print("finshed lisning");
              // Future.delayed(const Duration(seconds: 1),(){
              String captureText = Util.scanText(text);

              print(text);
              _toggleLight(captureText);

              // });
            }
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESP32 Voice Control'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    "Light 1",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: FlutterSwitch(
                      value: light1On,
                      onToggle: (value) {
                        //_toggleLight(lightNumber);
                      },
                      activeText: 'On',
                      inactiveText: 'Off',
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      toggleColor: Colors.white,
                      width: 100.0,
                      height: 40.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  const Text(
                    "Light 2",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: FlutterSwitch(
                      value: light2On,
                      onToggle: (value) {
                        //_toggleLight(lightNumber);
                      },
                      activeText: 'On',
                      inactiveText: 'Off',
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      toggleColor: Colors.white,
                      width: 100.0,
                      height: 40.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  const Text(
                    "Light 3",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: FlutterSwitch(
                      value: light3On,
                      onToggle: (value) {
                        //_toggleLight(lightNumber);
                      },
                      activeText: 'On',
                      inactiveText: 'Off',
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      toggleColor: Colors.white,
                      width: 100.0,
                      height: 40.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                                  const Text(
                    "Light 4",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: FlutterSwitch(
                      value: light4On,
                      onToggle: (value) {
                        //_toggleLight(lightNumber);
                      },
                      activeText: 'On',
                      inactiveText: 'Off',
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      toggleColor: Colors.white,
                      width: 100.0,
                      height: 40.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  const Text(
                    "Door Lock",
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  IgnorePointer(
                    ignoring: true,
                    child: FlutterSwitch(
                      value: doorLockOn,
                      onToggle: (value) {
                        //_toggleLight(lightNumber);
                      },
                      activeText: 'On',
                      inactiveText: 'Off',
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      toggleColor: Colors.white,
                      width: 100.0,
                      height: 40.0,
                    ),
                  ),
                ],
              ),
              //.............
              SingleChildScrollView(
                reverse: true,
                padding: const EdgeInsets.all(30).copyWith(bottom: 150),
                child: Center(
                  child: SubstringHighlight(
                    text: text,
                    terms: Command.all,
                    textStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    textStyleHighlight: const TextStyle(
                        fontSize: 32,
                        color: Colors.red,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
            onPressed: toggleRecoding,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              size: 36,
            )),
      ),
    );
  }
}