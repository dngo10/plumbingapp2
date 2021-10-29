import 'dart:math';

import 'package:myapp2/fixture-controller/fixture_unit.dart';

class Pair<T1, T2>{
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

class Zscore{
  static double z = 2.32634787404084;
  static double stagnation = 1;
  static double hunterNumber = 0;
  static double sumOfFixture = 0;
  static String methodReferred = '';
  static double finalGpm = 0;

  //This function will be called once at submit.
  static void valueInitiation(List<Fixture> fixtureList){
    double stagnation = 1;
    double hunterNumber = 0;
    double sumOfFixture = 0;

    

    for(int i = 0; i < fixtureList.length; i++){
      hunterNumber += fixtureList[i].amount!*fixtureList[i].curP!;
      sumOfFixture += fixtureList[i].amount!;
      if(fixtureList[i].amount! > 0){
        stagnation *= pow(1- fixtureList[i].curP!, fixtureList[i].amount!);
      }
    }
    Zscore.stagnation = stagnation;
    Zscore.hunterNumber = hunterNumber;
    Zscore.sumOfFixture = sumOfFixture;
  }
}


