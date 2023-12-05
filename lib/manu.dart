
import 'package:flutter/material.dart';
import 'package:flutter_iot/control.dart';
import 'package:flutter_iot/voiceControl.dart';
import 'component/CButtonComponent.dart';

class Manu extends StatelessWidget {
  const Manu({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();

    String greeting = getGreeting(currentTime)+" ESP 32";
    return  SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Manu Page'),
        // ),
        body: SingleChildScrollView(
          child: Column(
          
            children: [
              Container(
                width: double.infinity,
                height: 400,
                        child: Padding(
                        padding: const EdgeInsets.only(top: 20,left: 15),
                        child: Text(greeting,
                        style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        ),
                        //textAlign: TextAlign.center,
                        ),
                      ),
              ),
               Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: double.infinity,
                  padding: const EdgeInsets.all(2),
                      child: CButtonComponent(
                      text: 'Manual Switch',
                      paramTextStyle:const TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: Color.fromARGB(255, 35, 94, 161), 
                      ),
                      paramIcon: const Icon(Icons.speaker,size: 50),
                      onPressed: () {
                         Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ControlPage(),
                              ));

                      },
                    ),
                    ),
              const SizedBox(),
              Container(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  width: double.infinity,
                  padding: const EdgeInsets.all(2),
                      child: CButtonComponent(
                      text: 'Voice Automation',
                      paramTextStyle:const TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold, 
                                    color: Color.fromARGB(255, 63, 61, 156), 
                      ),
                      paramIcon: const Icon(Icons.record_voice_over,size: 50,color: Color.fromARGB(255, 74, 60, 150),),
                      onPressed: () {
                          Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VoiceControl(),
                              ));
                      },
                    ),
                    ), 
                    const SizedBox(),
          
               
            ],
          )
        ),
      ),
    );
  }
  String getGreeting(DateTime time) {
    final hour = time.hour;
    if (hour >= 6 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  } 
}