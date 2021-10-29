import 'package:myapp2/fixture-controller/case_ee.dart';
import 'package:myapp2/fixture-controller/fixture_unit.dart';
import 'data_fu.dart';

class EECalc{

  List<CaseEE> optionList = [];
  List<Fixture> currentListToCalculate = [];
  SampleOptionListIndex sampleOptionListIndex = SampleOptionListIndex.blank();
  CaseEE chosenOne = CaseEE.blank();

  //This is the list to flat out the number of fixtures.
  List<Pair<Fixture, bool>> exactedListToCalculate = [];

  EECalc(List<Fixture> currentList){
    Stopwatch s = new Stopwatch();
    currentListToCalculate = [...currentList];
    s.start();
    _exTractionList();
    s.stop();

    print("_exTractionList: ${s.elapsedMicroseconds}");

    s.reset();

    s.start();
    optionList = _getListRecursive(0, []);
    s.stop();
    print("_getListRecursive: ${s.elapsedMicroseconds}");

    s.reset();
    s.start();
    optionList.sort((caseE1, caseE2) => caseE1.gpm.compareTo(caseE2.gpm));
    s.stop();
    print("_Sorting: ${s.elapsedMicroseconds}");

    s.reset();
    s.start();

    chosenOne = calculateCumutativeProb();
    s.stop();
    print("calculateCumutativeProb: ${s.elapsedMicroseconds}");

    sampleOptionListIndex = SampleOptionListIndex(optionList.indexOf(chosenOne), optionList);
  }

  CaseEE calculateCumutativeProb(){
    int len = optionList.length;
    bool added = false;
    CaseEE chosenFixture = CaseEE([]);
    double prob = 0;
    for(int i = 0; i < len; i++){
      prob += optionList[i].busyTime;
      optionList[i].cumutativeProb = prob;
      if(prob > 0.99 && !added){
        if(i-1 < len && i-1 > 0){
          if(optionList[i-1].cumutativeProb < 0.9){
            chosenFixture = optionList[i];
          }else{
            chosenFixture = optionList[i-1];
          }
          len = (i + 2) < len ? (i + 2) : len;
          added = true;
        }
    //shorten calculation, no need to calculate the rest of list;
      }
    }
    return chosenFixture;
  }

  List<CaseEE> _getListRecursive(int index, List<Pair<Fixture, bool>> currentList){
    if(exactedListToCalculate.isEmpty) {
      return [];
    } else if(index == exactedListToCalculate.length) {
      return [CaseEE(currentList)];
    } else {
      List<Pair<Fixture, bool>> newList1 = [...currentList];
      List<Pair<Fixture, bool>> newList2 = [...currentList];
      newList1.add(Pair(exactedListToCalculate[index].first, true));
      newList2.add(Pair(exactedListToCalculate[index].first, false));
      return [... _getListRecursive(index + 1, newList2), ..._getListRecursive(index + 1, newList1)];
    }
  }

  void _exTractionList(){
    for (Fixture fixture in currentListToCalculate) {
      for(int i = 0; i < fixture.amount!; i++){
        exactedListToCalculate.add(Pair(fixture, false));
      }
    }
  }
}

class SampleOptionListIndex{
  int floorIndex = -1;
  int roofIndex = -1;
  int currentIndex = -1;

  List<CaseEE> sample = [];

  SampleOptionListIndex(int index, List<CaseEE> list){
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

  SampleOptionListIndex.blank(){}
}



/**
 * 
 * asynchronous and event-based programs by using observable sequences.
 * 1 core type: Observable.
 * satellite types: Observer, Schedulers, Subjects.
 * operators: map, filter, reduce, every.
 * 
 * Observable: represents the idea of an invokable collection of future values or events.
 * Observer: is a collection of callbacks that knows how to listen to values delivered by the Observable.
 * Subscription: represents the execution of an Observable, is primarily useful for cancelling the execution.
 * Operators: are pure functions that enable a funtional programming style of dealing with collections wit operations like map, filter, concat, reduce.
 * Subjects: is equivalent to an Event Emitter, and the only way of multicasting a value or event to multiple Observers.
 * Schedulers: are centralized dispatchers to control concurrency, allowing us to coordinate when computation happens one setTimeout or requestAnimationFrame or others.
 * 
 * Purity:
 * 
 * Ability to produce values using pure functions.
 * 
 * Flow:
 * 
 * Control how the events flow through your observables.
 * 
 * Observable:
 * 
 * passing messages between parts of your application.
 * -- technique for event handling, asynchronous programming, and handling mutliple values.
 * -- 
 * observer pattern is a software design pattern in which an object, called a subject, maintains
 * a list of its dependents, called observers, and notifies them automatically of state changes.
 * 
 * observables are declarative -- a function for publishing values, but it is not executed
 * until a consumer subscribes to it. The subscribed consumer then receives notifications until
 * the function completes or until they unsubscribe.
 * 
 * An observable can deliver multiple values of any type -- literals, messages, or events, depending
 * on the context.
 * 
 * Because setup and teardown logic are both handled by the observable, your application code only needs
 * to worry about subscribing to consume values, and when done, unsubscribing.
 * 
 * //----------------------
 * 
 * Publisher.
 *  create an Observable instance -> defines a subscriber function.
 *  function is executed when a consumer calls the subscribe() method.
 *  Subscriber function defines how to obtain or generate values or messages to be published.
 * 
 *  Observerable:
 *  
 *  Are lazy Push collections of multiple values.
 *  Pull and Push are two different protocols that describe how a data Producer can communicate with a data Consumer.
 * 
 *  Pull: Conversumer determines when it receives data from the data Producer.
 *        Producer itself is unaware of when the data will be delivered to the consumer.
 * 
 *  Push: The Producer determines when to send data to the Consumer. The Consumer is unaware of when it will receive that data.
 *        Promises are the most common type of Push system in Javascript today.
 * 
 *  Observables are like functions with zero arguments, but generalize those to allow multiple values.
 *  If you don't call the the observerable with subscribe, nothing happens.
 * 
 *  Subscribing to an Observable is analogous to calling a function.
 * 
 *  Observables are able to deliver values either synchronously or asynchronously.
 *  Subsribing to an Observable is like calling a function, providing callbacks where the data will be delivered to.
 *  
 *  The Subscription represents the ONGOIN execution.
 * 
 *  A Subject is like an Observable, but can multicast to many Observers.
 *  Subject are liek EventEmitters: they maintain a registry of many listeners.
 *  
 *  A "multicasted Observable" passes notifications through a Subject which may have many subscribers.
 * 
 *  BehaviorSubject:
 *  Stores the lastest value emitted to its consumers, and whenever a new Observer subscribes, it will immediately receive the "current value".
 * 
 *  A ReplaySubject:
 *  Records multiple values from the Observable execution and replays them to new subscriber.
 * 
 *  AsyncSubject:
 *  The AsyncSubject is variant where only the last value of the Observable execution is sent to its observers.
 *  
 *  
 * 
 * Observer:
 * 
 * Is a consumer of values delivered by an Observable.
 * Observers are simply a set of callbacks, one for each type of notification delivered by the Observable: next, error, and complete.
 * 
 * Operator:
 * 
 * Operators are functions. 2 kind:
 * 
 * Pipable Operators:
 *  are the kind that can be piped to Observables using the syntax observableInstance.pipe(operator())
 *  When called, they do not change the exsting Observable instance. Instead they return a new Observable, whose subscription logic is based
 * on the first Observable.
 * 
 *  A Pipeable Operator: takes an Observable as input and returns another Obserable.
 *  Subscribing to the output Observable will also subscribe to the input Observable.
 * 
 * Pipeable operators are functions, so they could be used like ordinary functions.
 * 
 * Creation Operators:
 *  are functions that can be used to create an Observable with some common predefiend behavior or by joining other Observables.
 * 
 * Higher-order Observables:
 *  Handle Observales of Observables -- meaning higher-order Observables.  
 * 
 * const fileObservable = urlObservable.pipe(
 *    map((url) => http.get(url)),
 *    concatAll()
 *   );
 *
 * concatAll(),
 * mergeAll(),
 * switchAll(),
 * exhaustAll(),
 * 
 * Marble diagrams: There is ALL operations to WALK THROUGH... 
 * 
 * Subscriptions:
 * 
 *  Is an object that represents a disposable resource.
 * 
 * Subject:
 * 
 *  RxJS Subject is a special type of Observable that allows values to be multicasted to many Observers.
 *  While plain Observables are unicast (each subscribed Observer owns an independent execution of the Observable),
 * Subjects are multicast.
 * 
 *  A Subject is like an Observable, but can multicast to many Observers.
 *  Subjects are like EventEmitters: they main a registry of many listeners.
 * 
 *  Every Subject is an Observable.
 *  From the perspective of the observer, it cannot tell whether the Observable execution is coming from 
 *  a plain unicast Observable or a Subject.
 * 
 *  Every subject is an Observer.
 *  IT is an object withmethods next(v), error(e), and complete().
 *  To feed new value to the Subject, just call next(theValue), and it will be multicasted.
 * 
 *  Since a Subject is an Observer, this also means you may provide a Subject a Subject as the argument to the subscribe
 *  of any Observable.
 * 
 *  Multicasted Observables:
 *  A "multicasted Observable" passes notifications through a Subject which may have many subscribers.
 *  Whereas a plain "unicast Observable" only sends notifications to a single Observer.
 *  
 *  Multicasted Observables: Observers subscribe to an underlying Subject, and the Subject subscribes to the source Observable.
 *  
 *  Multicast returns an Observable that looks like a normal Observable, but works like a Subject when it comes
 *  to subscribing. multicast returns a ConnectableObservable, which is simply an Observable with connect() method.
 * 
 *  The connect() method is important to determine exactly when the shared Observable execution will start.
 *  
 * 
 *  Handling
 *  
 * 
 * Every Subject is an Observer. It is an object with the methods next(v), error(e), and complete(). To feed
 * a new value to the Subject, just call next(theValue), and it will be multicasted to the Observers registered
 * to listen to the Subject.
 * 
 * Defining Observers:
 *  next      : requried. A handler for each delivered value. Called zero or more times after execution starts.
 *  error     : Optional. A handler for an error notification. An error halts execution of the observable instance.
 *  complete  : Optional. A handler for the execution-complete notifiation.
 * 
 * Subscribing:
 *  An Observerable instance begins publishing values only when someone subscribes to it.
 *  of(...items) -- Returns an Observable instance that synchronously delivers the values provided as arguments.
 *  from(iterable) -- Converts its argument to an Observable instance. This method is commonly used to convert
 *  an array to an observable.
 *  
 * Creating observables:
 * 
 * Use the Observable consstructor to create an observable stream of any type.
 * The constructor taks as its argument the subscriber function to run when the observable's subscribe() method executes.  
 * 
 * 
 * 
 * 
 * 
 */

/**
 * Angular Pipes:
 *  DatePipe: Formats a date value according to locale rules.
 *  UpperCasePipe: Tranforms text to all upper case.
 *  LowerCasePipe: Transforms text to all lower case.
 *  CurrencyPipe
 *  PercentPipe
 * 
 *  Binding a property
 *  [ngClass] = "classes"
 *  [ngClass -- Angular]
 *  
 *  
 */