import 'package:flutter/material.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:sunrise_sunset/sunrise_sunset.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ancient Indian Clock',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'கடிகாரம்'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _nazhigai = 0, _nimisham = 0, _vinadi = 0;
  double locationLat, locationLong;
  DateTime _sunrise, _sunset;
  Timer _timer;
  String _localTime;

  var _kizhamai = [
    'ஞாயிற்றுக்கிழமை',
    'திங்கட்கிழமை',
    'செவ்வாய்',
    'புதன்கிழமை',
    'வியாழன்',
    'வெள்ளி',
    'சனிக்கிழமை',
  ];

  var _muhurtham = [
    'ருத்ரா',
    'ஆஹீ',
    'மித்ரா',
    'பித்ரா',
    'வாசு',
    'வராஹ',
    'விஸ்வதேவா',
    'விதி',
    'சுதமுகி',
    'புரூஹுதா',
    'வாகினா',
    'Naktanakarā (नक्तनकरा)',
    'வருணா',
    'ஆர்யமன்',
    'பாகா',
    'Girīśa (गिरीश)',
    'அஜபாதா',
    'Ahir-Budhnya (अहिर्बुध्न्य)',
    'புஷ்யா',
    'அஸ்வினி',
    'யமா',
    'அக்னி',
    'Vidhātṛ (विधातृ)',
    'Kaṇḍa (क्ण्ड)',
    'அதிதி',
    'ஜீவ',
    'விஷ்ணு',
    '	Dyumadgadyuti (द्युमद्गद्युति)',
    'பிரம்மா',
    'சமுத்திரம்'
  ];

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    //Default to Toronto region.
    locationLat = 37.4219983;
    locationLong = -122.084;

    _vinadi = 0;
    _nimisham = 0;
    _nazhigai = 0;

    _localTime = "";

    _resetCounter();

    _timer = new Timer.periodic(Duration(milliseconds: 400), (timer) {
      _incrementCounter();
      //print("Timer running" );
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _resetCounter();
  }

  void getLocation() async {
    print("getLocation()");
    Location location = new Location();
    LocationData _locationData;
    _locationData = await location.getLocation();
    print('GetLocation():$_locationData');
    locationLat = _locationData.latitude;
    locationLong = _locationData.longitude;
    //print (lo.toString();
  }

  void getSunRise() async {
    double na, ni, vi;
    int elapsedMilli;
    await getLocation();

    //today := Date

    var response = await SunriseSunset.getResults(
      date: DateTime.now().toLocal(),
      latitude: locationLat,
      longitude: locationLong,
    );

    if (response.success) {
      var data = response.data;
      _sunrise = data.sunrise.toLocal();
      _sunset = data.sunset.toLocal();
      elapsedMilli = DateTime.now().millisecondsSinceEpoch -
          _sunrise.millisecondsSinceEpoch;
      //If elapsed is -ve then take yesterday's date.-
      if (elapsedMilli < 0) {
        var yday = new DateTime.now().toLocal().subtract(Duration(days: 1));
        print('Its post 12 so getting yesterdays date');
        response = await SunriseSunset.getResults(
          date: yday,
          latitude: locationLat,
          longitude: locationLong,
        );
      }
    }

    if (response.success) {

      var data = response.data;
      _sunrise = data.sunrise.toLocal();
      _sunset = data.sunset.toLocal();
      elapsedMilli = DateTime.now().millisecondsSinceEpoch -
          _sunrise.millisecondsSinceEpoch;

      vi = elapsedMilli / 400;
      ni = vi / 60;
      na = ni / 60;
      _nazhigai = na.toInt();
      _nimisham = ni.toInt() % 60;
      _vinadi = vi.toInt() % 60;
      print('Sunrise: $_sunrise');
      print('Sunset: $_sunset');
      // print('Timezone name: $TZ');
    } else {
      print(response.error);
    }
  }

  void _incrementCounter() {
    DateTime today = new DateTime.now();
    setState(() {
      _localTime = "இன்று:  ${today.month.toString().padLeft(2,'0')}/${today.day.toString().padLeft(2,'0')}  "
          "${_kizhamai[today.weekday]}  "
          "${today.hour.toString().padLeft(2,'0')}:${today.minute.toString().padLeft(2,'0')}:${today.second.toString().padLeft(2,'0')}";
      //_localTime = "_"
      _vinadi = _vinadi + 1;
      if (_vinadi > 59) {
        _nimisham++;
        _vinadi = 0;
      }
      if (_nimisham > 59) {
        // Pull the sun-raise / sun-set information.
        _nazhigai++;
        _nimisham = 0;
      }

      if (_nazhigai > 59) {
        _resetCounter();
      }
    });
  }

  void _resetCounter() {
    setState(() {
      getSunRise();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child:
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
            Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              _localTime,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .apply(fontWeightDelta: 2, fontSizeFactor: 0.75),
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'நாழிகை',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      _nazhigai.toString().padLeft(2,'0'),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .apply(fontSizeFactor: 0.75),
                    ),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'விநாழிகை',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .apply(fontWeightDelta: 2),
                    ),
                    Text(
                      _nimisham.toString().padLeft(2,'0'),
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .apply(fontSizeFactor: 0.75),
                    ),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'நொடி',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(fontWeightDelta: 2, fontSizeFactor: 0.50),
                    ),
                    Text(
                      _vinadi.toString().padLeft(2, '0'),
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .apply(fontSizeFactor: 0.50),
                    ),
                  ]),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'முகூர்த்தம்:   ',
              style: Theme.of(context).textTheme.bodyText1.apply(fontWeightDelta: 2, color: Colors.blueGrey),
            ),
            Text(
              _muhurtham.elementAt((_nazhigai ~/ 2).abs()),
              style: Theme.of(context).textTheme.bodyText1.apply(fontWeightDelta: 2,  color: Colors.orange),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'சூரிய உதயம்: ',
              //_sunrise.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              _sunrise.toString(),
              //_sunrise.toString(),
              style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.orange),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'சூரிய அஸ்தமனம்:  ',
              //_sunrise.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .apply(fontWeightDelta: 2),
            ),
            Text(
              _sunset.toString(),
              //_sunrise.toString(),
              style: Theme.of(context).textTheme.bodyText1.apply(color: Colors.orange),
            ),
          ]),
        ]),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _resetCounter,
            tooltip: 'reset',
            child: Icon(Icons.refresh),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
//          FloatingActionButton(
//            onPressed: _incrementCounter,
//            tooltip: 'add',
//            child: Icon(Icons.add_circle),
//          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ],
      ),
    );
  }
}