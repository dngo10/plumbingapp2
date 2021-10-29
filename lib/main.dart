import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp2/pages/edit.dart';
import 'package:myapp2/pages/result.dart';
import 'package:provider/provider.dart';

import 'fixture-controller/fixture_list.dart';
import 'fixture-controller/fixture_unit.dart';
import 'fixture-controller/fl_controller.dart';


main(){
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget{

  @override
  State<StatefulWidget> createState(){
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    
    futureWait().then((value){
      setState(() {});
    });
  }

  Future<double> futureWait() async{
    await FixtureController.whc.readFile();
    await FixtureController.fl.getFixtureList();
    await FixtureController.readData();
    return 1;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FixtureController.fl),
        ChangeNotifierProvider(create: (context) => FixtureController.whc),
      ],
      child: MaterialApp(
      title: 'Gouvis Plumbing Waterheater Choosing',
      theme: ThemeData(
        fontFamily: 'Monofonto',
        primarySwatch: Colors.blue,
        ),
          home: MyHomePage(),
        )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  ListContainer(),
      appBar: AppBar(
        title: const Text("Weater Heater Choosing"),
        leading: IconButton(onPressed: ()=>{}, icon: const Icon(Icons.access_time)),
        centerTitle: true,
      ),
      floatingActionButton:  FloatingActionButton(onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(Fixture.newBlank())))},
                 child: const Icon(Icons.add), mini: false,),
    );
  }
}

class ListContainer extends StatefulWidget{
  @override
  State<ListContainer> createState() => _ListContainer();
}

class _ListContainer extends State<ListContainer>{

  TextEditingController numOfDwellingCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    numOfDwellingCtrl.text = FixtureController.fl.numberOfApartment.toString();

    return Consumer<FixtureList>(builder: (context, nouse1, nouse2) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20, right: 100),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                const Expanded(
                  child: Text("Enter Number of Dwelling: ", textAlign: TextAlign.end,),
                  flex: 1
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: numOfDwellingCtrl,
                    decoration: const InputDecoration(hintText: '1'),
                  ),
                  width: 50,
                ),
                Expanded(
                  child:
                  Align(child: MaterialButton(
                    child: Row(children: [
                      Container(
                        child: const Icon(Icons.autorenew),
                      )
                    ],),
                    
                    onPressed: () {assignNumberOfApartment();},
                    ),
                    alignment: Alignment.centerLeft,),
                  flex: 1
                ),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: (){
                      FixtureController.reset();
                      //Hotfix, shouldn't be this way.
                      numOfDwellingCtrl.text = "1";
                    },
                    child: Row(
                      children: [ 
                        Container(
                          child: const Icon(Icons.restart_alt),
                          margin: const EdgeInsets.only(right: 5),
                        ),                     
                        Text("Reset")
                      ],
                    ),
                  ),
                )
              ],
              ),
            ),
            Expanded(child: TableInformation()),
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 30),
              child: MaterialButton(
                onPressed: () {
                  //This run ONCE and ONCE only, generate all kind of RESULT
                  FixtureController.getResults();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
                },
                child: Column(children: [
                  Icon(
                    Icons.calculate,
                    color: Theme.of(context).primaryColor
                    ),
                  Text(
                    "Calculate Results",
                    style: TextStyle(color: Theme.of(context).primaryColor )
                  )
                ]),
              )
            )
          ]
        ),
      );
    }
    );
  }

  void assignNumberOfApartment(){
    int? numOfDwelling = int.tryParse(numOfDwellingCtrl.text);
    if(numOfDwelling != null){
      FixtureController.fl.assignNumOfAparment(numOfDwelling);
    }
  }
}

class TableInformation extends StatelessWidget{
  const TableInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
        columnSpacing: 70,
        columns: const <DataColumn>[
          DataColumn(
            label:  Text('name'),
          ),
          DataColumn(
            label: Text('amount'),
          ),
          DataColumn(
            label: Text('prop'),
          ),
          DataColumn(
            label: Text('gpm'),
          ),
          DataColumn(
            label: Text('edit'),
          ),
          DataColumn(
            label: Text('delete'),
          ),         
        ],
        rows: FixtureController.fl.getItems().map<DataRow>(
          (Fixture fixture) =>  
            DataRow(cells: <DataCell>[
              DataCell(Text(fixture.name)),
              DataCell(Text(fixture.amount.toString(), textAlign: TextAlign.right,)),
              DataCell( fixture.curP == -1 ? const Text("N/A") : Text((fixture.curP!*100).toStringAsFixed(2) + " %", textAlign: TextAlign.right,)),
              DataCell(Text(fixture.gpm.toString(), textAlign: TextAlign.right,)),
              DataCell(const Icon(Icons.edit), onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(fixture)))
              }),
              DataCell(const Icon(Icons.delete), onTap: () => {
                FixtureController.fl.removeItemObject(fixture)
              }),
            ]) 
        ).toList(),
      ),
    )
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

/**
 * Data flow in forms:
 *  As users change values and make selections through the view, the new values must be reflected in the data model.
 *  When the program logic changes values in the data model, those values must be reflected in the view.
 *  
 *  view to model:
 *  
 *  1. user types a value into the input element.
 *  2. input elemnt emits an "input" event with latest value.
 *  3. control value accessor listening for events on the form input element, immediately relays the new value to the FormControl instance.
 *  4. The FormControl instance emits the new value through the value Changes observable.
 *  5. Any subscribers to the value Changes obsevable receive the new value.
 * 
 *  model to view:
 *  
 *  1. The user calls the favoriteColorControl.setValue() method. Which updates the FormControl value.
 *  2. The FormControl instance emeits emits the new value through the valueChanges observable.
 *  3. Any subcribers to the value Changes observable receive the new value.
 *  4. The control value accessor on the ofmr input elemnt updates the elemnt with the new values.
 * 
 * 
 *  Mutability of the data model
 * 
 *  1. Reactive forms:
 *    Each time a change is triggered on the data model, the FormControl instance returns a new data model rather than
 *    updating the existing data model.
 * 
 *  2. With readtive forms, the FormControl instance always returns a new value when the control's value is updated.
 *    Reactive forms use an explicit and immutable approach to managing the state of a form at a given point in time.
 * 
 *  Adding a basic form control:
 * 
 *    1. Register the reactive forms module in your application. This module declares the reactive-form directives
 *    that you need to use reactive forms.
 * 
 *    2. Generator a new FormControl instance and save it in the component.
 * 
 *    3. Register the FormControl in the template.
 * 
 *    app.module.ts
 * 
 *    import {ReactiveFormsModule} form '@angular/forms';
 * 
 *    @NgModule({
 *      imports: [ReactiveFormsModule]
 *    })
 * 
 *    name-editor.component.ts
 * 
 *    import {FormControl} form '@angular/forms';
 * 
 *    name = new FormControl('');
 * 
 *    Use the constructor of FormControl to set its initial value, which is this case is an empty string.
 *    
 *    [formControl]="name"
 *    FormControl to set its intial value, which is in this case: empty
 *    
 *    
 *    
 */


