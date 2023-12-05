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

  
 
 // Track the state of the door lock
  bool doorLockOn = false;

   final String esp32IpAddress =
      '192.168.1.100'; 


  
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
      _sendCommand('26', light1On ? 'on' : 'off');
    } else if (lightNumber == Command.switchTwo) {

        light2On = !light2On;
      _sendCommand('27', light2On ? 'on' : 'off');
    } else if (lightNumber == Command.switchThree) {

       light3On = !light3On;
      _sendCommand('14', light3On ? 'on' : 'off');
    }
    else if (lightNumber == Command.doorlock) {

       doorLockOn = !doorLockOn;
      _sendCommand('12', doorLockOn ? 'high' : 'low');
    }
    else if(lightNumber == Command.allLightOn){
  
     // Future.delayed(const Duration(seconds: 1),(){
        if(!light1On){light1On = true;_sendCommand('26', light1On ? 'on' : 'off');}
    //  });
     // Future.delayed(const Duration(seconds: 1),(){
        if(!light2On){light2On = true;_sendCommand('27', light2On ? 'on' : 'off');}
     // });
     // Future.delayed(const Duration(seconds: 1),(){
        if(!light3On){light3On = true;_sendCommand('14', light3On ? 'on' : 'off');}
     // });
      
    }
    else if(lightNumber == Command.allLightOff){
     
        if(light1On){light1On = false;_sendCommand('26', light1On ? 'on' : 'off');}
      
      
        if(light2On){light2On = false;_sendCommand('27', light2On ? 'on' : 'off');}
      
      
        if(light3On){light3On = false;_sendCommand('14', light3On ? 'on' : 'off');}
      
    }
    print(lightNumber+" "+Command.allLightOn);
  }

  
 

  @override
  void initState() {
    super.initState();
  
  }


Future toggleRecoding() => SpeachApi.toggleRecoding(
      onResult: (text) => setState(()=>this.text =text),
      onListning: (isListening) { 
        setState(() {
          this.isListening = isListening;

          if(!isListening){
            print("finshed lisning");
           // Future.delayed(const Duration(seconds: 1),(){
             String captureText =  Util.scanText(text);

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
      body: Center(
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
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
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
                SizedBox(height: 20.0),
              ],
            ),
            //.............
            SingleChildScrollView(
              reverse: true,
              padding: const EdgeInsets.all(30).copyWith(bottom: 150),
              child: Center(
                child: SubstringHighlight(
                  text: text,
                  terms:Command.all,
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w300
                  ),
                  textStyleHighlight: const TextStyle(
                    fontSize: 32,
                    color: Colors.red,
                    fontWeight: FontWeight.w400
                  ),
                  ),
                
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:  AvatarGlow(
        animate: isListening,
        endRadius: 75,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
      
          onPressed: toggleRecoding,
          child: Icon(isListening ? Icons.mic:Icons.mic_none,size: 36,)),
      ),
    );
  }


}