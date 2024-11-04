import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:iirjdart/butterworth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  AndroidDeviceInfo? _androidInfo;

  UserAccelerometerEvent? _accelerometerEvent;
  final Duration _accelerometerSampling = const Duration(milliseconds: 10);
  final _streamSubscription = <StreamSubscription<dynamic>>[];

  double accelEuclidianVal = 0.0;

  List<FlSpot> accelPoints = List<FlSpot>.filled(1000, const FlSpot(0.0, 0.0));
  int pointsIdx = 0;
  bool fullSize = false;

  Butterworth butterworth = Butterworth();
  double lastFilterValue = 0.0;
    


  @override
  initState(){
    super.initState();
    getAndroidModel();
    initAccelerometer();
    initFilter();
  }

  void initFilter(){
    butterworth.lowPass(4, 1000/_accelerometerSampling.inMilliseconds, 2);
  }

  Future<void> getAndroidModel() async{
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    setState(() {
          _androidInfo = androidInfo;
    });
  }

  Future<void> initAccelerometer() async{
    _streamSubscription.add(
      userAccelerometerEventStream(samplingPeriod: _accelerometerSampling).listen(
      (UserAccelerometerEvent event) {
        setState((){
          _accelerometerEvent = event;
          accelEuclidianVal = sqrt(pow(_accelerometerEvent!.x, 2) + pow(_accelerometerEvent!.y, 2) + pow(_accelerometerEvent!.z, 2));
          lastFilterValue = butterworth.filter(accelEuclidianVal);
          if (pointsIdx < accelPoints.length){
            accelPoints[pointsIdx] = FlSpot(pointsIdx.toDouble(), lastFilterValue);
            pointsIdx++;
          }else{pointsIdx = 0;}

      });
      },
      cancelOnError: true,
      )
    );
  }

  
  Future<void> popUpError(String e) async{
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(
              e),
        );
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Running on: ${_androidInfo?.model}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Accelerometer'
              ),
            Text(
              '${_accelerometerEvent?.x.toStringAsFixed(3)} ${_accelerometerEvent?.y.toStringAsFixed(3)} ${_accelerometerEvent?.z.toStringAsFixed(3)}'
            ),
            Text(
              accelEuclidianVal.toString()
            ),
            const Text(
              "Last filter value"
            ),
            Text(
              lastFilterValue.toString()
            ),
            AspectRatio(
              aspectRatio: 2.0,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 1000.0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: accelPoints,
                      dotData: const FlDotData(
                        show: false,
                      ),
                    ),
                  ],
                ),
                duration: const Duration(milliseconds: 0),
              ),
            ), 
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => popUpError("A"),
        tooltip: 'Debug',
        child: const Icon(Icons.developer_board_off),
      ),
    );
  }
}
