import 'dart:math';

import 'package:myapp2/fixture-controller/fixture_unit.dart';

import 'data_fu.dart';




class WistortMethod{
  static double mean = 0;
  static double standardDev = 0;
  static double result = 0;

  static void getWaterDemand(List<Fixture> fixtureList){
    List<Fixture> defaultList = <Fixture>[];

    for(int i = 0; i < fixtureList.length; i++){
      defaultList.add(fixtureList[i]);
    }

    mean = _getMean(defaultList);
    standardDev = _getStandardDeviation(fixtureList);


    result =  mean + standardDev;
  }

  static double _getMean(List<Fixture> fixtureList){
    double result = 0;
    for (Fixture fixture in fixtureList){
      result += fixture.amount!*fixture.curP!*fixture.gpm!;
    }

    return result;
  }

  static double _getStandardDeviation(List<Fixture> fixtureList){
    double result = 0;
    for(Fixture fixture in fixtureList){
      result += fixture.amount!*fixture.curP!*(1 - fixture.curP!)*pow(fixture.gpm!, 2);
    }

    result = sqrt(result);
    result *= Zscore.z;

    return result;
  }
}