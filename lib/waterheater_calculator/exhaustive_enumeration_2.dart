import 'dart:math';

import 'package:myapp2/fixture-controller/fixture_unit.dart';
import 'package:myapp2/waterheater_calculator/data_fu.dart';

class ExhaustiveEnumeration2{
  List<Fixture> currentFixtures;
  List<List<num>> resultList = [];
  List<List<num>> combiList = [[]];

  Map<int, Map<int, List<num>>> precalcMap = {};

  ExhaustiveResult eResult = ExhaustiveResult.blank();

  ExhaustiveEnumeration2(this.currentFixtures){
    precalcOptions(currentFixtures);
  
    int z = 0;

    for(int i = 0; i < currentFixtures.length; i++){
      num maxZ = combiList.length;
      z = 0;
      while(z < maxZ){
        List<num> temp = combiList[z];
        combiList.removeAt(z);
        for(num j = 0; j <= currentFixtures[i].amount!; j++){
          if(currentFixtures[i].amount! <= 0) break;
          List<num>temp2 = [...temp, j];
          combiList.add(temp2);
          if(i == (currentFixtures.length - 1)){
            resultList.add(addInFormation(temp2));
          }
        }
        maxZ--;
      }
    }
    if(resultList.length > 1){
      resultList.sort((a, b) => a[1].compareTo(b[1]));
    }
    
    eResult = ExhaustiveResult(resultList);
  }

  //[options, gpm, prob] <-- this is where the index comeFrom
  List<num> addInFormation(List<num> initialList){
    num gpm = 0;
    num combiAmount = 1;
    num tt = 1;
    num bt = 0;

    for(int i = 0; i < initialList.length; i++){
      if(currentFixtures[i].amount! <= 0) continue;
      combiAmount *= precalcMap[i]![initialList[i]]![0];
      gpm += precalcMap[i]![initialList[i]]![1];
      tt *=  precalcMap[i]![initialList[i]]![2];
    }

    if(gpm == 0){
      tt = 0;
      bt = 0;
    }else{
      bt = tt/(1.0 - Zscore.stagnation);
    }

    List<num> result = [combiAmount, gpm, tt, bt];
    return result;
  }

  double _ncr(num n, num r){
      if (r == 0) return 1;
      if (r > n / 2) return _ncr(n, n - r); 
      double res = 1; 
      for (int k = 1; k <= r; ++k)
      {
          res *= n - k + 1;
          res /= k;
      }
      return res;
  }  

  void precalcOptions(List<Fixture> fixtures){

    for(int i = 0; i < fixtures.length; i++){
      Map<int, List<num>> newMap = {};
      for(int j = 0; j <= fixtures[i].amount!; j++){
        num options = _ncr(fixtures[i].amount!, j);
        num gpm = j*fixtures[i].gpm!;
        num prob = pow(fixtures[i].curP!, j)*pow(1 - fixtures[i].curP!, fixtures[i].amount! - j);
        if(prob == 0) {prob = 1;}
        newMap.putIfAbsent(j, () => [options, gpm, prob]);
      }
      precalcMap.putIfAbsent(i, () => newMap);
    }
  }
}


class ExhaustiveResult{
  List<List<num>> resultList = [];  //[combiAmount, gpm, tt, bt, cmprob] sorted

  double candidate1 = 0;
  int index = 0;
  num gpm = 0;

  ExhaustiveResult(this.resultList){

    if(resultList.isEmpty) return;

    double temp = 0;
    for(int i = 0; i < resultList.length; i++){
      temp = candidate1 + resultList[i][0]*resultList[i][3];
      if(temp < 0.99){
        candidate1 = temp;
      }else if(temp >= 0.99){
        if((temp - 0.99).abs() < (candidate1 - 0.99).abs()){
          index = i;
        }else{
          if(i == 0) {
            index = i;
          } else {
            index = i -1;
          } 
        }        
        break;
      }
    }
    gpm = resultList[index][1];
  }

  ExhaustiveResult.blank(){}
}