import 'dart:math';

import 'package:myapp2/fixture-controller/fixture_unit.dart';

import 'data_fu.dart';


class ModifedWistortMethod{

  static double result = 0;

  static void getWaterDemand(List<Fixture> fixtureList){
    List<double> i = npq(fixtureList);
    result = (1.0/(1 - Zscore.stagnation))*(i[0] + (1+Zscore.stagnation)*Zscore.z*sqrt((1-Zscore.stagnation)*i[1] - Zscore.stagnation*pow(i[0], 2)));
  }

  static List<double> npq(List<Fixture> fixtureList){
    double npq1 = 0;
    double npq2 = 0;

    for(int i = 0; i < fixtureList.length; i++){
      npq1 += fixtureList[i].amount!*fixtureList[i].curP!*fixtureList[i].gpm!;

      npq2 += fixtureList[i].amount!*
                 fixtureList[i].curP!*
                 (1 - fixtureList[i].curP!)*
                 pow(fixtureList[i].gpm!, 2);
    }
    return [npq1, npq2];
  }
}