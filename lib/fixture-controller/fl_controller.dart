import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:myapp2/waterheater_calculator/data_fu.dart';
import 'package:myapp2/waterheater_calculator/exhaustive_enumeration_2.dart';
import 'package:myapp2/waterheater_calculator/hunter.dart';
import 'package:myapp2/waterheater_calculator/modifed_wistort_method.dart';
import 'package:myapp2/waterheater_calculator/waterheater_choice/waterheater_choice.dart';
import 'package:myapp2/waterheater_calculator/wistort_method.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'fixture_list.dart';
import 'fixture_unit.dart';

class FixtureController{
  static String url = "https://service9.de/api/data";
  static bool isEditing = false;

  static bool setUpPreviousChoice = true;

  static Uri uri =  Uri.parse(url);

  static FixtureList fl = FixtureList();
  static WaterHeaterChoice whc = WaterHeaterChoice();

  static const _fixtureList = "fixtureList";
  static const _waterHeaterChoice = "waterHeaterChoice";

  static const _data = "Data";
  static const _uuid = "Uuid";

  static String uuid = "";

  static void reset(){
    //DO NOT TOUCH ASYNC FUNCTIONS
    fl.reset();
    whc.reset();
  }

  static Map<String, dynamic> _toMap(){
    return {
      _fixtureList : fl.toMap(),
      _waterHeaterChoice : whc.toMap()
    };
  }

  static Map<String, dynamic> createBodyMap(){
    if(!isEditing){
      var uuID = const Uuid();
      uuid = uuID.v4();
    }

    return{
      _uuid: uuid,
      _data: jsonEncode(_toMap()),
    };
  }

  static String toJson(){
    return jsonEncode(createBodyMap());
  }

  static void fromJson(String json){
    Map<String, dynamic> result = jsonDecode(json);
    if(result.containsKey(_uuid)){
      uuid = result[_uuid] as String;
    }
    Map<String, dynamic> data1 = jsonDecode(result[_data]);
    fl.fromMap(data1[_fixtureList] as Map<String, dynamic>);
    whc.fromMap(data1[_waterHeaterChoice] as Map<String, dynamic>);
  }

  static readData() async{
    RegExp rg = RegExp(r'^\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b$');
    ClipboardData? data = await Clipboard.getData('text/plain');
    String? temp = data!.text;
    if(rg.hasMatch(temp!.trim())){
      String uuid = temp.trim();
      http.Response response = await http.get(Uri.parse(url + "/$uuid"));
      
      if(response.statusCode < 300){
        isEditing = true;
        await Clipboard.setData(const ClipboardData(text: ''));  
        FixtureController.fromJson(response.body);
      }
    }
  }

  static MethodRepresentation methods = MethodRepresentation([]);

  static void getResults(){
    methods = MethodRepresentation(fl.getItems());
  }

}


class MethodRepresentation{
  ExhaustiveEnumeration2 exh = ExhaustiveEnumeration2([]);
  HunterMethod hunter = HunterMethod([]);
  double noneDefinedGpm = 0; 
  double numOfFixture = 0;
  int chosenMethod = 0;

  MethodRepresentation(List<Fixture> fixtures){
    List<Fixture> nondefinedFixtures = [];
    List<Fixture> definedFixtures = [];
    
    
    

    //Only check p20 to specify.
    for (Fixture fixture in fixtures) {
      if(fixture.p20 == -1){
        nondefinedFixtures.add(fixture);
        numOfFixture += fixture.amount!;
      }else{
        definedFixtures.add(fixture);
      }
    }

    Zscore.valueInitiation(definedFixtures);

    //Wistort
    WistortMethod.getWaterDemand(definedFixtures);
    
    ModifedWistortMethod.getWaterDemand(definedFixtures);

    if(numOfFixture <= 30){
      exh = ExhaustiveEnumeration2(definedFixtures);
    }

    getGpmOfUndefined(nondefinedFixtures);

    hunter = HunterMethod(fixtures);

    if(numOfFixture <= 30){
      chosenMethod = 0;
      Zscore.methodReferred = "Exhastive Enumeration";
      Zscore.finalGpm = exh.eResult.gpm + noneDefinedGpm;
    }else if(numOfFixture > 30 || Zscore.hunterNumber < 5){
      chosenMethod = 1;
      Zscore.methodReferred = "Modified Wistort Method";
      Zscore.finalGpm = ModifedWistortMethod.result + noneDefinedGpm;
    }else if(Zscore.hunterNumber >= 5){
      chosenMethod = 2;
      Zscore.methodReferred = "Wistort Method";
      Zscore.finalGpm = WistortMethod.result + noneDefinedGpm;
    }
  }

  void getGpmOfUndefined(List<Fixture> fixtures){
    noneDefinedGpm = 0;
    for (Fixture fixture in fixtures) {
      noneDefinedGpm += fixture.amount!*fixture.gpm!;
    }
  }


}


/**
 * State Management:
 *  
 * In the broadest possible sense, the state of an app is everything that exists in memory when the app is running.
 * 
 * Ephenmeral state: is the state you can neatly contain in a single widget.
 * 
 * State that is not ephemeral, that you want to share across many parts of your app, and that you
 * want to keep between user sessions, is what we call application state.
 * 
 * App state:
 * 
 * That you want to keep between user sessions, is what we call application state.
 * 
 * User preferences.
 * Login info
 * Notifications in a social networking app
 * The shopping cart in an e-commerce app.
 * Read/unread state of articles in a news app.
 * 
 * -- Construct a new widget every time its contents change.
 * -- In Flutter, it makes sense to keep the state above the widgets that use it.
 * -- 
 * 
 */

/**
 * Routing:
 * 
 * AppRoutingModule
 * 
 * 3 fundamental building blocks to creating a route:
 * 
 * 1. Import the AppRoutingModule into AppModule and add it to imports array.
 * 2. Define your routes in your Routes array.
 * 3. Add your routes to your application. <routerLink="/path" routerLinkActive="active"/>
 * 
 * Getting Route information:
 * 
 * To get information from a route:
 * 1. Import ActivatedRoute and ParaMap to your component.
 * 
 * import {Router, ActivatedRoute, ParaMap} from '@angular/router';
 * To display a 404 page, set up a wildcard route with the component property set to the
 * component you'd like to use for your 404 page as follows:
 * 
 * ** This path should be the last path
 * {path: '**', component: PageNotFoundComponent}
 * 
 * Nesting routes: (read it, easy)
 * 
 *    <li><a routerLink="child-a">Child A</a></li>
 *    <li><a routerLink="child-b">Child B</a></li>
 * 
 *    https://angular.io/guide/router#nesting-routes
 * 
 * Relative paths
 *    allow you to define paths that are relative to the current URL segment.
 *    <li><a routerLink="../second-component">Relative Route to second component</a>
 * 
 *    goToItems() {
 *      this.router.navigate(['items'], { relativeTo: this.route });
 *    }
 * 
 * Accessing query parameters and fragments:
 * 
 * Lazy loading:
 * 
 * Preventing unauthorized access:
 * 
 * ng generate guard your-guard
 * 
 * export class YourGuard implements CanActivate {
 *   canActivate(
 *     next: ActivatedRouteSnapshot,
 *     state: RouterStateSnapshot): boolean {
 *       // your  logic goes here
 *   }
 * }
 * 
 * 
 * 
 * Common form foundation classes:
 * 
 *  FormControl: tracks the value and validation status of an individual form control.
 *  FormGroup: tracks the same values and status for a collection of form controls.
 *  FormArray: tracks the same values and status for an array of form controls.
 *  ControlValueAccessor: creates a bridge between Angular FormConrol instances and native DOM elements.
 * 
 * 
 * Setup in reactive forms:
 *    
 * [formControl]  
 * 
 * A form grouop defines a form with a fixed set of controls
 * 
 * Create a FormGroup instance:
 * 
 * export class ProfileEditorComponent{
 *    profileForm = new FormGroup({
 *      firstName: new FormControl(''),
 *      lastName: new FormControl(''),
 *    });
 * }
 * 
 * Save form data: using ngSubmit()
 * 
 * Display the component:
 * 
 * Nested form groups:
 * 
 * Form groups can acdept both individual form control + other form group.
 * 
 * Updating parts of the data model:
 * 
 * When updating the value for a form group instance that contains multiple controls, you may only want to update
 * parts of the model. This section covers how to update specific parts of a form control data forms.
 * 
 * Control status CSS classes:
 * 
 * .ng-valid[required], .ng-valid.reequired{}
 *    
 *  HTTP Client
 *  It's important to include observe and responType option.  
 *  import { HttpHeaders } from '@angular/common/http';
 * 
 *  const httpOptions = {
 *    headers: new HttpHeaders({
 *      'Content-Type':  'application/json',
 *      Authorization: 'my-auth-token'
 *    })
 *  };
 * 
 *  update Header:
 * 
 *  httpOptions.headers =
 *  httpOptions.headers.set('Authorization', 'my-new-auth-token');
 * 
 *  You can then inject the HttpClient service as a dependency of an application class.
 *  options objects:
 * 
 *  options: {
 *    headers? : HttpHeaders | {[header: string] : string | string[]},
 *    observe? : 'body' | 'events' | 'response',
 *    params? : HttpParams | {[param: string] : string | number | boolean | ReadonlyArray ???}
 *  }
 * 
 *  To specify the response object type
 *  Use an interface rather than class.
 * 
 *  export interface Config{
 *    heroesUrl: string;
 *    textfile: string; 
 *    date: any; 
 *  }
 * 
 *  Then: add it:
 * 
 *  getConfig(){
 *    return this.http.get<Config>(this.configUrl);
 *  }
 * 
 * Show the config:
 * 
 *  config: Config | undefined;
 *  showConfig(){
 *    this.configService.getConfig().subscribe((data: Config) -> this.config = {...data});
 *  }
 * 
 * 
 */