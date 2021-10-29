import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp2/fixture-controller/fixture_unit.dart';
import 'package:myapp2/fixture-controller/fl_controller.dart';

class EditPage extends StatelessWidget{
  Fixture fixture;
  bool isNew = false;
  String regPattern = r'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)';
  String currentValue = "Check";

  EditPage(this.fixture, {Key? key}) : super(key: key){
      if(fixture.name != ""){
        TempFixtureValue.nameCtrl.text = fixture.name;
        TempFixtureValue.amountCtrl.text = fixture.amount.toString();
        TempFixtureValue.propCtrl.text = fixture.p1.toString();
        TempFixtureValue.gpmCtrl.text = fixture.gpm.toString();
        TempFixtureValue.factorCtrl.text = fixture.factorx.toString();
        TempFixtureValue.expCtrl.text = fixture.exponential.toString();
        TempFixtureValue.outNumCtrl.text = fixture.p20.toString();

        TempFixtureValue.fixUnitCtrl.text = fixture.fixtureUnit.toString();
        TempFixtureValue.coldFixUnitCtrl.text = fixture.coldWaterFixtureUnit.toString();
        TempFixtureValue.hotFixUnitCtrl.text = fixture.hotWaterFixtureUnit.toString();
      }else{
        isNew = true;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit/Update Fixture"),
      ),
      body: getDataInputInterface(),
      floatingActionButton: FloatingActionButton(
        child: isNew ? const Icon(Icons.add_shopping_cart) : const Icon(Icons.published_with_changes),
        onPressed: (){
          if(isNew){
            FixtureController.fl.addItem(adjustedFixture());
          }else{
            FixtureController.fl.modifyFixture(fixture, adjustedFixture());
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget getDataInputInterface(){
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: 
      SingleChildScrollView(
      child: Column(
        children: [
                  const Text("EDIT"),

                  Container(
                      child: const Text(
                        "Predefined Fixtures",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      padding: const EdgeInsets.only(top: 30, bottom: 10)
                  ),
                  DropDownMenu(),

                  Row(
                    children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(right: 30),
                        child: Column(
                          children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Fixture Name',
                          ),
                          controller: TempFixtureValue.nameCtrl
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Amount'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: TempFixtureValue.amountCtrl,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Probability (P1)'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(regPattern))],
                          controller: TempFixtureValue.propCtrl,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'GPM'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(regPattern))],
                          controller: TempFixtureValue.gpmCtrl,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Factor'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(regPattern))],
                          controller: TempFixtureValue.factorCtrl
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Exponential'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)?'))], //DIFFERENT REG, NEED +-
                          controller: TempFixtureValue.expCtrl
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Probability when dwellings > 20 (P20)'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(regPattern))],
                          controller: TempFixtureValue.outNumCtrl
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Water Supply Fixture Unit'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(regPattern))],
                          controller: TempFixtureValue.fixUnitCtrl
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Cold Water Fixture Unit'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)?'))], //DIFFERENT REG, NEED +-
                          controller: TempFixtureValue.coldFixUnitCtrl
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Hot Water Fixture Unit'
                          ),
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)?'))], //DIFFERENT REG, NEED +-
                          controller: TempFixtureValue.hotFixUnitCtrl
                        ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: const Text(
                              "NOTES: Below is instruction of how to get probability of multiple dwellings",
                              style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                            alignment: Alignment.centerLeft,
                          ),

                        Container(
                          child: const Image(
                            image: AssetImage('assets/images/probabilityEquation.png'),
                            fit: BoxFit.scaleDown
                          ),
                          width: 400,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(bottom: 30),
                        ),

                        const SizedBox(
                          width: 400,
                          child: Image(
                            image: AssetImage('assets/images/table9.png'),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        ],
                      ),
                    )  
                  ],
                ),
              ],
            ),
      )
    );
  }

  ///
  ///This will return a fixture based on data inserted
  Fixture adjustedFixture(){
    Fixture newFixture = Fixture.newBlank();

    newFixture.name = TempFixtureValue.nameCtrl.text;
    newFixture.amount = _isNumeric(TempFixtureValue.amountCtrl.text);
    newFixture.p1 =  _isNumeric(TempFixtureValue.propCtrl.text); 
    newFixture.gpm = _isNumeric(TempFixtureValue.gpmCtrl.text); 
    newFixture.factorx = _isNumeric(TempFixtureValue.factorCtrl.text);
    newFixture.exponential = _isNumeric(TempFixtureValue.expCtrl.text);
    newFixture.p20 = _isNumeric(TempFixtureValue.outNumCtrl.text);

    newFixture.fixtureUnit = _isNumeric(TempFixtureValue.fixUnitCtrl.text);
    newFixture.hotWaterFixtureUnit = _isNumeric(TempFixtureValue.hotFixUnitCtrl.text);
    newFixture.coldWaterFixtureUnit = _isNumeric(TempFixtureValue.coldFixUnitCtrl.text);
    newFixture.getProbability(FixtureController.fl.numberOfApartment);

    return newFixture;
  }

  double? _isNumeric(String s) {
    return double.tryParse(s);
  }
}

class DropDownMenu extends StatefulWidget{
  const DropDownMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DropDownMenu();
  }
}

class _DropDownMenu extends State<DropDownMenu>{
  String currentValue = FixtureController.fl.getInitialItems().first.name;

  @override
  Widget build(BuildContext context) {
    Fixture tempFixture = Fixture.newBlank();

    return DropdownButton(
      value: currentValue,
      items: 

      FixtureController.fl.getInitialItems().map<DropdownMenuItem<String>>(
        (Fixture fixture) {
          return DropdownMenuItem<String>(value: fixture.name, child: Text(fixture.name));
        }
      ).toList(),
      onChanged: (String? value1) => {setState((){
        tempFixture = FixtureController.fl.getInitItemsFromName(value1!);
        currentValue = tempFixture.name;
        TempFixtureValue.nameCtrl.text = tempFixture.name;
        TempFixtureValue.amountCtrl.text = tempFixture.amount.toString();
        TempFixtureValue.propCtrl.text = tempFixture.p1.toString();
        TempFixtureValue.gpmCtrl.text = tempFixture.gpm.toString();
        TempFixtureValue.factorCtrl.text = tempFixture.factorx.toString();
        TempFixtureValue.expCtrl.text = tempFixture.exponential.toString();
        TempFixtureValue.outNumCtrl.text = tempFixture.p20.toString();
        TempFixtureValue.fixUnitCtrl.text = tempFixture.fixtureUnit.toString();
        TempFixtureValue.hotFixUnitCtrl.text = tempFixture.hotWaterFixtureUnit.toString();
        TempFixtureValue.coldFixUnitCtrl.text = tempFixture.coldWaterFixtureUnit.toString();
        }
        )},
    );
  }
}

class TempFixtureValue{
  static TextEditingController nameCtrl = TextEditingController();
  static TextEditingController amountCtrl =  TextEditingController();
  static TextEditingController propCtrl =    TextEditingController();
  static TextEditingController gpmCtrl =     TextEditingController();
  static TextEditingController factorCtrl =  TextEditingController();
  static TextEditingController expCtrl =     TextEditingController();
  static TextEditingController outNumCtrl =  TextEditingController();
  static TextEditingController fixUnitCtrl =  TextEditingController();
  static TextEditingController hotFixUnitCtrl =  TextEditingController();
  static TextEditingController coldFixUnitCtrl =  TextEditingController();
}