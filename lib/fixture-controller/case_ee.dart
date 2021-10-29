import 'package:myapp2/fixture-controller/fixture_unit.dart';
import 'package:myapp2/waterheater_calculator/data_fu.dart';

class CaseEE{
  List<Pair<Fixture, bool>> casE = [];
  double gpm = 0;
  double prob = 1;
  double busyTime = 0; //Column 13 in calculation
  double cumutativeProb = 0; // based ON column 14

  CaseEE.blank(){}

  CaseEE(List<Pair<Fixture, bool>> caseEE){
    this.casE = caseEE;
    calculateProp();
  }

  void calculateProp() {
    for(Pair<Fixture, bool> fixPair in casE){
      if(fixPair.second){
        gpm += fixPair.first.gpm!;
        prob *= fixPair.first.curP!;
      }else{
        prob *= (1.0 - fixPair.first.curP!);
      }
    }

    if(gpm == 0) {
      prob = 0;
      busyTime = 0;
    }else{
      busyTime = prob/(1- Zscore.stagnation);
    }
  }
}