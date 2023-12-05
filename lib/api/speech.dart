import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeachApi {

  static final _speech = SpeechToText();

  static Future<bool> toggleRecoding({
    required Function(String text) onResult,
    required ValueChanged<bool> onListning,
    }) async{

      if(_speech.isListening){
          _speech.stop();
          return true;
      }

      final isAvailable  = await _speech.initialize(
        onStatus: (status) => onListning(_speech.isListening),
        onError: (errorNotification) => print(errorNotification),
      );

      if(isAvailable){
          _speech.listen(onResult: (result) => 
          onResult(result.recognizedWords)
          );
      }

      return isAvailable;

  }

}