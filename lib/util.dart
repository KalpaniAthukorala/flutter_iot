


class Command{

  static final all = [switchOne,switchTwo,switchThree,switchTo,doorlock,switch1,switch2,
                      switch3,dholak,lightOne,lightTwo,lightThree,lightto,firstLight,
                      secondLight,thirdLight,allLightOn,allLightOff,allLightOf,allSwitchOn,allSwitchOff,allSwitchOf,
                      switchFour,lightFour,fourthLight,switch4,forl,doorUnlock,dhoUnlak,dhoUnloc];

  static const switchOne = 'light one';
  static const switchTwo = 'light two';
  static const switchTo = 'light to';
  static const switchThree = 'light three';
  static const switchFour = 'light four';

  static const lightOne = 'switch one';
  static const lightTwo = 'switch two';
  static const lightThree = 'switch three';
  static const lightto = 'switch to';
  static const lightFour = 'switch four';

  static const firstLight = 'first light';
  static const secondLight = 'second light';
  static const thirdLight = 'third light';
  static const fourthLight = 'fourth light';

  static const switch1 = 'light 1';
  static const switch2 = 'light 2';
  static const switch3 = 'light 3';
  static const switch4 = 'light 4';

  static const forl = 'for';

  static const allLightOn = 'all light on';
  static const allLightOff = 'all light off';
  static const allLightOf = 'all light of';

  static const allSwitchOn = 'all switch on';
  static const allSwitchOff = 'all switch off';
  static const allSwitchOf = 'all switch of';

  //door lock
  static const doorlock = 'door lock';
  static const dholak = 'dholak';
  //do unlock  do unloc

  static const doorUnlock = 'door unlock';
  static const dhoUnlak = 'do unlock';
  static const dhoUnloc = 'do unloc';
  

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
    if(text.contains(Command.doorUnlock) || text.contains(Command.dhoUnlak) || text.contains(Command.dhoUnloc)){
        final body =  _getTextAfterCommand(text:text,command:Command.doorUnlock);

        return body;
    }
    if(text.contains(Command.allLightOn) || text.contains(Command.allSwitchOn) ){
        final body =  _getTextAfterCommand(text:text,command:Command.allLightOn);

        return body;
    }
    if(text.contains(Command.allLightOff) || text.contains(Command.allSwitchOff) || text.contains(Command.allSwitchOf)
      || text.contains(Command.allLightOf)){
        final body =  _getTextAfterCommand(text:text,command:Command.allLightOff);

        return body;
    }
    if(text.contains(Command.switchFour) || text.contains(Command.lightFour) 
      || text.contains(Command.fourthLight) || text.contains(Command.switch4) 
      || text.contains(Command.forl)){
        final body =  _getTextAfterCommand(text:text,command:Command.switchFour);

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