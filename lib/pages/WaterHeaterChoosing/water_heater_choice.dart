import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp2/fixture-controller/fl_controller.dart';
import 'package:myapp2/waterheater_calculator/data_fu.dart';
import 'package:myapp2/waterheater_calculator/waterheater_choice/waterheater_choice.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//import 'package:url_launcher/url_launcher.dart';

class WaterHeaterChoosing extends StatefulWidget{
  WaterHeaterChoosing({Key? key}) : super(key: key);

  String brand    = FixtureController.whc.brand;
  String maxCap   = FixtureController.whc.maxCap;
  String maxCap45 = FixtureController.whc.maxCap45;
  String btu      = FixtureController.whc.btu;
  String eFactor  = FixtureController.whc.eFNs;
  String pumpType = FixtureController.whc.pumpType;

  List<WaterHeater1> wHeater = FixtureController.whc.wHeaters;

  @override
  State<StatefulWidget> createState() => _WaterHeaterChoosing();
}

class _WaterHeaterChoosing extends State<WaterHeaterChoosing>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Heater Choosing"),
      ),
      body: Consumer<WaterHeaterChoice>(
        builder: (context, nouse1, nouse2){
        return SingleChildScrollView(
          child: Container(
          padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
          alignment: Alignment.topCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Row(children: [
                        const SizedBox(child: Text("Brand: "), width: 120,),
                        Expanded(child: DropDownMenu<String>(widget.brand, FixtureController.whc.brandsL)),
                        ],
                      ),
                      Row(children: [
                        const SizedBox(child: Text("Pump Type: "), width: 120),
                        Expanded(child: DropDownMenu<String>(widget.pumpType, FixtureController.whc.pumpTypeL)),],
                      ),
                      Row(children: [
                        const SizedBox(child: Text("Max Capacity: "), width: 120),
                        Expanded(child: DropDownMenu<double>(widget.maxCap, FixtureController.whc.maxCapL)),
                        ],
                      ),
                      Row(children: [
                        const SizedBox(child: Text("Rise at 45: "), width: 120),
                        Expanded(child: DropDownMenu<double>(widget.maxCap45, FixtureController.whc.capAt45L)),
                        ],
                      ),
                      Row(children: [
                        const SizedBox(child: Text("Btu: "), width: 120),
                        Expanded(child: DropDownMenu<double>(widget.btu, FixtureController.whc.btuL)),],
                      ),
                      Row(children: [
                        const SizedBox(child: Text("Enegy Factor: "), width: 120),
                        Expanded(child: DropDownMenu<double>(widget.eFactor, FixtureController.whc.eFactorL)),],
                      ),
                      Container(
                        child: ElevatedButton(
                          child: const Text("Check"),
                          onPressed: (){
                            FixtureController.whc.choose();
                          },
                        ),
                        padding: const EdgeInsets.only(top: 20),
                      ),
                      Container(child: const Text("Choosen Water Heater", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.only(top: 20),
                          ),
                      CurrentChoosen(),
                      Container(
                        child: ElevatedButton(
                          child: const Text("SUBMIT"),
                          onPressed: (){
                            String jso = FixtureController.toJson();
                            String chossenJson = FixtureController.whc.choosenOne.toJson();
                            Clipboard.setData(ClipboardData(text: chossenJson)).then((_){
                                if(FixtureController.isEditing){
                                  http.post(
                                    Uri.parse(FixtureController.url + "/edit"),
                                    body: jso,
                                    headers: <String,String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                    }
                                  ).then((value) {
                                    if(value.statusCode > 300){
                                      print("Failed -- Status Code: ${value.statusCode}");
                                    }else{
                                      exit(0);
                                    }
                                  });
                                }else{
                                  http.post(
                                    FixtureController.uri,
                                    body: jso,
                                    headers: <String,String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                    }
                                  ).then((value){
                                    if(!kReleaseMode){
                                      print(FixtureController.uuid);
                                    }     
                                  if(value.statusCode >= 200 && value.statusCode < 300){
                                    exit(0);
                                  }else{
                                    print("status code: ${value.statusCode}");
                                    print("can't add to server");
                                  }
                                });
                                }
                            },
                          );
                        },
                          style: ElevatedButton.styleFrom(primary: Colors.red)
                        ),
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 30, bottom: 50)
                      )
                    ]
                  ),
                ),
                width: 300,
              ),
              Expanded(
                flex: 3, 
                child: Column(
                  children:[
                    Text("Total GPM: ${Zscore.finalGpm.toStringAsPrecision(2)} (gpm)"),
                    Text("Hot GPM (50% total): ${(Zscore.finalGpm/2.0).toStringAsPrecision(2)} (gpm)"),
                    Container(
                    child: WaterHeatersChoosing(),
                    alignment: Alignment.topCenter,
                  ),
                ]
              ),
              )
            ],
          )
      ),
        );
    },
    )
    );
  }
}

class WaterHeatersChoosing extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _WaterHeatersChoosing();
  }
}

class _WaterHeatersChoosing extends State<WaterHeatersChoosing>{
  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(label: Text("check")),
        DataColumn(label: Text("Brand")),
        DataColumn(label: Text("Model")),
        DataColumn(label: Text("Pump Type")),
        DataColumn(label: Text("Max GPM")),
        DataColumn(label: Text("Btu/Hr")),
        DataColumn(label: Text("Energy Eff"))
      ],
      rows: FixtureController.whc.chosenWeaterHeaters.map(
        (e)=>(
          DataRow(
            cells: <DataCell>[
              DataCell(Icon(e.check ? Icons.check_box : Icons.check_box_outline_blank)),
              DataCell(Text(e.brand)),
              DataCell(Text(e.model.toUpperCase())),
              DataCell(Text(e.pumpType)),
              DataCell(Text(e.maxCap.toStringAsFixed(1))),
              DataCell(Text(e.btu.toStringAsFixed(0))),
              DataCell(Text((e.eFactor * 100).toStringAsFixed(0)))
            ],
            onSelectChanged: (selected){
              FixtureController.whc.setChoosenFalse();
              if(selected!){
                e.check = true;
                FixtureController.whc.chooseAnother(e);
              }
            }
          )
        )
      ).toList()
    );
  }
}

class DropDownMenu<T> extends StatefulWidget{
  List<T> items = [];
  String hKey = '';
  DropDownMenu(this.hKey, this.items, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DropdownMenu<T>();
  }
}

class _DropdownMenu<T> extends State<DropDownMenu>{
  List<T> items = <T>[];
  var value;
  String hKey = '';

  _DropdownMenu(){
    
    if(T == String){
      if(!items.isEmpty){
        value = items[0];
      }else{
        value = 'All'; // This should never happen
      }
      
    }else if(T == double){
      value = -1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    hKey = widget.hKey;
    items = <T>[...widget.items];

    if(items.isEmpty){
      return const Text("Loading");
    }

    return DropdownButton<T>(
      isExpanded: true,
      value: value,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 20,
      onChanged: (T? newValue) {
        setState(() {
          FixtureController.whc.requestPara[hKey] = newValue;
          value = newValue!;
        });
      },
      items: items.map<DropdownMenuItem<T>>((T e){
        return DropdownMenuItem(
          value: e,
          child: Text(getValue(e)),
        );
      }).toList()
    );
  }

  String getValue( e){
    if(e is String){
      return e;
    }else {
      double value  = e;
      if(value == -1.0) {
        return 'No Limit';
      } else {
        return value.toStringAsFixed(2);
      }
    }
  }
}


class CurrentChoosen extends StatefulWidget{
  TextEditingController labelController = TextEditingController();
  TextEditingController numbController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return _currentChoosen();
  }
}

class _currentChoosen extends State<CurrentChoosen>{
  double? wid = 125;

  @override
  Widget build(BuildContext context) {
    widget.labelController.text = FixtureController.whc.choosenOne.label;
    widget.numbController.text = FixtureController.whc.choosenOne.numb;
    widget.locationController.text = FixtureController.whc.choosenOne.location;


    return Container(
      child: Column(
        children: [
          Row(children: [
            SizedBox(child: const Text('Label: ',), width: wid),
            SizedBox(child: 
              TextField(
                controller: widget.labelController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "TWH"
                  ),
                onChanged: onLabelChange,
                ),
              width: wid,
            )

          ]),

          Row(children: [
            SizedBox(child: const Text('Tag#: '), width: wid),
            SizedBox(
              child: TextField(
                controller: widget.numbController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "1"
                ),
                onChanged: onNumbChange,
              ),
              width: wid,
            )
          ]),

          Row(children: [
            SizedBox(child: const Text('Location: '), width: wid),
            SizedBox(
              child: TextField(
                controller: widget.locationController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "some where"
                ),
                onChanged: onLocationChange,
              ),
              width: wid,
            )
          ]),

          Row(children: [
            SizedBox(child: const Text('Brand:'), width: wid,),
            Text(FixtureController.whc.choosenOne.brand),
          ],),

          Row(children: [
            SizedBox(child: const Text('Model:'), width: wid),
            Text(FixtureController.whc.choosenOne.model.toUpperCase()),
          ],),

          Row(children: [
            SizedBox(child: const Text('Pump Type: '), width: wid,),
            Text(FixtureController.whc.choosenOne.pumpType),
          ],),

          Row(children: [
            SizedBox(child: const Text('Vent Type: '), width: wid,),
            Text(FixtureController.whc.choosenOne.ventType),
          ],),

          Row(children: [
            SizedBox(child: const Text('Max GPM: '), width: wid),
            Text(FixtureController.whc.choosenOne.maxCap.toStringAsFixed(2)),
          ],),

          Row(children: [
            SizedBox(child: const Text('GPM at 45 Raise: '), width: wid),
            Text(FixtureController.whc.choosenOne.capAt45.toStringAsFixed(2)),
          ],),

          Row(children: [
            SizedBox(child: const Text('BTU/Hr: '), width: wid),
            Text(FixtureController.whc.choosenOne.btu.toStringAsFixed(0) ),
          ],),

          Row(children: [
            SizedBox(child: const Text('Energy Efficiency: '), width: wid),
            Text((FixtureController.whc.choosenOne.eFactor * 100).toStringAsFixed(0) + "%"),
          ],),

          Row(children:
            [
              SizedBox(child: const Text('Dimension WxHxD: '), width: wid),
              Text(FixtureController.whc.choosenOne.getDimensions()),
            ],
          ),

          Row(children:
            [
              SizedBox(child: const Text('Operating Weight: '), width: wid),
              Text(FixtureController.whc.choosenOne.getOperationWeight()),
            ],
          ),
          Row(children:
            [
              SizedBox(child: const Text('Gas Connection: '), width: wid),
              Text(FixtureController.whc.choosenOne.getGasConnection()),
            ],
          ),
          Row(children:
            [
              SizedBox(child: const Text('Combustion Air: '), width: wid),
              Text(FixtureController.whc.choosenOne.combustionAir),
            ],
          ),
          Row(children:
            [
              SizedBox(child: const Text('Exhaust Air: '), width: wid),
              Text(FixtureController.whc.choosenOne.exhaustAir),
            ],
          ),
          Row(children:
            [
              SizedBox(child: const Text('Electric Supply: '), width: wid),
              Text(FixtureController.whc.choosenOne.electricSupply),
            ],
          ),
          Row(children:
            [
              SizedBox(child: const Text('Electric Power: '), width: wid),
              Text(FixtureController.whc.choosenOne.getElectricPow()),
            ],
          ),

          Row(children:
            [
              SizedBox(child: const Text('Link: '), width: wid),
              ElevatedButton(
                              child: const Icon(Icons.link),
                              onPressed: (){_launchURL(FixtureController.whc.choosenOne.link);},
                            ),
            ],
          ),
        ],
      )
    );
  }

  void _launchURL(String _url) async{
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  onLabelChange(String value){
    FixtureController.whc.choosenOne.label = value;
  }

  onNumbChange(String value){
    FixtureController.whc.choosenOne.numb = value;
  }

  onLocationChange(String value){
    FixtureController.whc.choosenOne.location = value;
  }

}