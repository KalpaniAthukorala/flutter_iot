


class Command{

  static final all = [switchOne,switchTwo,switchThree,switchTo,doorlock,switch1,switch2,
                      switch3,dholak,lightOne,lightTwo,lightThree,lightto,firstLight,
                      secondLight,thirdLight,allLightOn,allLightOff,allSwitchOn,allSwitchOff];

  static const switchOne = 'light one';
  static const switchTwo = 'light two';
  static const switchTo = 'light to';
  static const switchThree = 'light three';

  static const lightOne = 'switch one';
  static const lightTwo = 'switch two';
  static const lightThree = 'switch three';
  static const lightto = 'switch to';

  static const firstLight = 'first light';
  static const secondLight = 'second light';
  static const thirdLight = 'third light';

  static const switch1 = 'light 1';
  static const switch2 = 'light 2';
  static const switch3 = 'light 3';

  static const allLightOn = 'all light on';
  static const allLightOff = 'all light off';

  static const allSwitchOn = 'all switch on';
  static const allSwitchOff = 'all switch off';

  //door lock
  static const doorlock = 'door lock';
  static const dholak = 'dholak';
  

}

class Util{
  

  static String scanText(String rawText){
    final text = rawText.toLowerCase();
    if(text.contains(Command.switchOne) || text.contains(Command.switch1) || text.contains(Command.lightOne)
        || text.contains(Command.firstLight)){
        final body =  _getTextAfterCommand(text:text,command:Command.switchOne);
        return body;
    }
    if(text.contains(Command.switchTwo) || text.contains(Command.switch2) 
        || text.contains(Command.switchTo) || text.contains(Command.lightTwo )|| text.contains(Command.lightto)
        || text.contains(Command.secondLight)){
        final body =  _getTextAfterCommand(text:text,command:Command.switchTwo);

        return body;
    }
    if(text.contains(Command.switchThree) || text.contains(Command.switch3)|| text.contains(Command.lightThree)
        || text.contains(Command.thirdLight)){
        final body =  _getTextAfterCommand(text:text,command:Command.switchThree);

        return body;
    }
    if(text.contains(Command.doorlock) || text.contains(Command.dholak)){
        final body =  _getTextAfterCommand(text:text,command:Command.doorlock);

        return body;
    }
    if(text.contains(Command.allLightOn) || text.contains(Command.allSwitchOn)){
        final body =  _getTextAfterCommand(text:text,command:Command.allLightOn);

        return body;
    }
    if(text.contains(Command.allLightOff) || text.contains(Command.allSwitchOff)){
        final body =  _getTextAfterCommand(text:text,command:Command.allLightOff);

        return body;
    }
    return "×	Some Word not clear..";
  }
  
  static _getTextAfterCommand(
    {required String text, required String command}
    ) {
        return command;
    }

}