import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/fixture-controller/fl_controller.dart';
import 'package:myapp2/waterheater_calculator/modifed_wistort_method.dart';

class ModifiedWistort extends StatefulWidget{
  const ModifiedWistort({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ModifiedWistort();
  }

}

class _ModifiedWistort extends State<ModifiedWistort>{


  @override
  Widget build(BuildContext context) {
   String res = ''; 
   if(FixtureController.methods.noneDefinedGpm != 0){
      res += "= ${ModifedWistortMethod.result.toStringAsPrecision(3)} ";
      res += "+ ${FixtureController.methods.noneDefinedGpm.toStringAsPrecision(3)} "; 
    }
    res += "= ${(ModifedWistortMethod.result + FixtureController.methods.noneDefinedGpm).toStringAsPrecision(3)} (gpm)"; 

    return  Column(
      children: [
        Container(
          child: const Text("Modified Wistort's method"),
          padding: const EdgeInsets.only(top: 50, bottom: 50),
        ),
        const Image(image: AssetImage('assets/images/modified_Wirtort.png')),
        const Image(image: AssetImage('assets/images/P_0.png')),
        Container(
          child: Text(res),
          alignment: Alignment.centerLeft,
          width: 200,
          padding: const EdgeInsets.only(top: 30),      
        )
      ],
    );
  }
}