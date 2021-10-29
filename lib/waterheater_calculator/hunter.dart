import 'package:myapp2/fixture-controller/fixture_unit.dart';
import 'package:myapp2/waterheater_calculator/data_fu.dart';

import 'data_file.dart';

class HunterMethod{

  Pair<double, double> valveTank = Pair(0, 0);
  Pair<double, double> flushTank = Pair(0, 0);

  Pair<double, double> hotValveTank = Pair(0, 0);
  Pair<double, double> hotFlushTank = Pair(0, 0);

  Pair<double, double> coldValveTank = Pair(0, 0);
  Pair<double, double> coldFlushTank = Pair(0, 0);

  SampleIndex valveSample = SampleIndex.blank();
  SampleIndex flushSample = SampleIndex.blank();

  List<Fixture> fixtures = [];

  double sum = 0;
  double hotSum = 0;
  double coldSum = 0;

  HunterMethod(this.fixtures){
    getSumFixtureUnit();

    valveTank = FuGpm.fuGpm.firstWhere((element) => element.first >= sum);
    flushTank = FuGpm.fuFGpm.firstWhere((element) => element.first >= sum);

    hotValveTank = FuGpm.fuGpm.firstWhere((element) => element.first >= hotSum);
    hotFlushTank = FuGpm.fuFGpm.firstWhere((element) => element.first >= hotSum);

    coldValveTank = FuGpm.fuGpm.firstWhere((element) => element.first >= coldSum);
    coldFlushTank = FuGpm.fuFGpm.firstWhere((element) => element.first >= coldSum);

    valveSample = SampleIndex(FuGpm.fuGpm.indexOf(valveTank), FuGpm.fuFGpm);
    flushSample = SampleIndex(FuGpm.fuFGpm.indexOf(flushTank), FuGpm.fuFGpm);
  }

  void getSumFixtureUnit(){
    for(Fixture fixture in fixtures){
      sum +=     fixture.amount! * fixture.fixtureUnit!;
      hotSum +=  fixture.amount! * fixture.hotWaterFixtureUnit!;
      coldSum += fixture.amount! * fixture.coldWaterFixtureUnit!;
    }
  }
} 

class SampleIndex{
  int floorIndex = -1;
  int roofIndex = -1;
  int currentIndex = -1;

  List<Pair<double, double>> sample = [];

  SampleIndex(int index, List<Pair<double, double>> list){
    currentIndex = index;
    if(index == 0 || index == 1 || index == 2){
      floorIndex = 0;
      roofIndex = 4;
    }else if(index == list.length-1 || index == list.length-2 || index == list.length -3){
      floorIndex = list.length - 5;
      roofIndex = list.length -1;
    }else{
      floorIndex = index - 2;
      roofIndex = index + 2;
    }

    for(int i = floorIndex; i <= roofIndex; i++){
      sample.add(list[i]);
    }
  }

  SampleIndex.blank();
}