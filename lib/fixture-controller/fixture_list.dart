
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:myapp2/fixture-controller/fixture_unit.dart';

class FixtureList extends ChangeNotifier{
  int numberOfApartment = 1;
  final _numberOfApartment = "numOfApart";

  List<Fixture> _currentFixtureList = [] ;
  final _currentList = "currentList";

  List<Fixture> _fixtureList = [];

  FixtureList() {}

  Map<String, dynamic> toMap(){
    List<Map<String, dynamic>> fixturelist = [];
    for(int i = 0; i < _currentFixtureList.length; i++){
      fixturelist.add(_currentFixtureList[i].toMap());
    }
    return {_currentList : fixturelist,
            _numberOfApartment : numberOfApartment
    };
  }

  void reset(){
    //DOES NOT RESET THE DEFAULT ORIGINAL DATA TEXT FILE
    _currentFixtureList = [];
    numberOfApartment = 1;
    notifyListeners();
  }

  void fromMap(Map<String, dynamic> map){
    _currentFixtureList.clear();
    numberOfApartment = map[_numberOfApartment];
    List<dynamic> fixtureList = map[_currentList] as List<dynamic>;
    for(int i = 0; i < fixtureList.length; i++){
      Fixture fix = Fixture.newBlank();
      Map<String, dynamic> m = fixtureList[i] as Map<String, dynamic>;
      fix.fromMap(m);
      _currentFixtureList.add(fix);
    }
    notifyListeners();
  }

  Future<List<Fixture>> getFixtureList() async {
    return await rootBundle.loadString('assets/data/data_origin.txt').then(
      (String value){
        List<String> lines = value.split('\n');
        for (int i = 1; i < lines.length; i++) {
          String line = lines[i];
          List<String> details = line.split('\t');
          String name = details[0];
          double? p1 = double.parse(details[1]);
          double? p20 = double.parse(details[2]);
          double? gpm = double.parse(details[3]);
          double? fu = double.parse(details[4]);
          double? cfu = double.parse(details[5]);
          double? hfu = double.parse(details[6]);
          double? exp = double.parse(details[7]);
          double? factorx = double.parse(details[8]);
          String tag = details[9];
          String num = details[10];
          Fixture fixture = Fixture(name, p1, gpm, exp, factorx, p20, fu, cfu, hfu, tag, num);
          _fixtureList.add(fixture);
        }
        getCurrentProposition(numberOfApartment);
        return _fixtureList;
      } 
    );
  }

  void getCurrentProposition(int numofApartment){
    numberOfApartment = numofApartment;
    if(_currentFixtureList.isEmpty) return ;

    for (Fixture fixture in _currentFixtureList) {
      if(fixture.curP == -1) continue;
      fixture.getProbability(numberOfApartment);
    }
  }

  void assignNumOfAparment(int numofApartment){
    getCurrentProposition(numofApartment);
    notifyListeners();
  }

  List<Fixture> getInitialItems(){
    return _fixtureList;
  }

  void resetCurrentItems(){
    for (Fixture fixture in _fixtureList) {
      _currentFixtureList.add(Fixture.copy(fixture));
    }
    notifyListeners();
  }

  Fixture getInitItemsFromName(String name){
    return Fixture.copy(_fixtureList.firstWhere((element) => element.name == name));
  }
  
  List<Fixture> getItems(){
    return _currentFixtureList;
  }

  void modifyFixture(Fixture originalFixture, Fixture modifedFixture){
    originalFixture.copy(modifedFixture);
    originalFixture.getProbability(numberOfApartment);
    notifyListeners();
  }

  void addItem(Fixture item){
    _currentFixtureList.add(item);
    notifyListeners();
  }

  void addItemInitial(Fixture item){ // Add Items based on selected tag, no need to notify.
    _currentFixtureList.add(item);
  }

  void removeItemObject(Fixture fixture){
    _currentFixtureList.remove(fixture);
    notifyListeners();
  }
}

/**
 * Angular
 * 
 * @Input() decorator
 * 
 * //CHILD
 * export class A{
 *    @Input() hero! : Hero;
 *    @Input('abc') masterName = '';
 * }
 * 
 * 
 * //PARENT
 * 
 * <app-hero-child *ngFor="let hero of heroes"
 *    [hero] = "hero"
 *    [abc] = "master"
 * >
 * </app-hero-child>
 * 
 * **Intercept input property changes with a setter
 * 
 * export class NameChildComponent{
 *    private _name;
 * 
 *    @Input()
 *    get name(): string {return this._name;}
 * 
 *    set name(name: string){
 *      this._name = (name && name.trim()) || '<no name set>';
 *    }
 * }
 * 
 * **Parent listens for child event
 * 
 * export class VoterComponent{
 *    @Input() name = '';
 *    @Output() voted = new EventEmitter<boolean>();
 *    didVote = false;
 * 
 *    vote(agreed: boolean){
 *      this.voted.emit(agreed);
 *      this.didVote = true;
 *    }
 * }
 * 
 * **Parent intereacts with child using local variable
 * 
 *   In this case you use the #variable to get the property out.
 *   You interact with child component through TEMPLATE LVL ONLY.
 * 
 * 
 * **Parent calls an @ViewChild
 * 
 * You can use view child to access to A CHILD.
 * 
 * @export class A implement ngAfterViewInit{
 *    @ViewChild(ChildComponent)
 *    private childComponent: ChildComponent;
 * }
 * 
 * // The ngAfterViewInit() is important. The timer isn't available until after
 * Angular displays the parent view.
 * 
 * ** Parent and Children communicate using a service
 * 
 * component-style:
 * 
 * :host
 * 
 * pseudo-class selector to target styles in the element that hosts the component.
 * 
 * You can't reach the host element from inside the component with other slectors
 * 
 * Conditional content projection:
 * 
 * If your component needs to conditionally render content
 * 
 * ngTemplateOutlet
 * 
 * 
 * 
 */