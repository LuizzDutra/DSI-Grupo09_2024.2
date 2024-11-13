/*Projeto da cadeira de DSI 2024.2 do grupo 09
  O projeto se refere a construção de um medidor de frequência cardíaca
  através dos acelerômetros do smarthphone*/

/*Neste projeto foi utilizado um algoritmo para medição baseado no seguinte artigo
Payette J, Vaussenat F, Cloutier SG. 
Heart Rate Measurement Using the Built-In Triaxial Accelerometer from a Commercial Digital Writing Device. 
Sensors. 2024; 24(7):2238. 
https://doi.org/10.3390/s24072238 
*/

import 'dart:async';
import 'dart:math';
import 'package:app_gp9/animation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:iirjdart/butterworth.dart';


class CustomGraphData{
  int size;
  List<FlSpot> data = <FlSpot>[];

  CustomGraphData(this.size);

  void addData(FlSpot spot){
    if (data.length < size){
      data.add(spot);
    }else{
      for (int i = 0; i < size-1; i++){
        data[i] = data[i+1];
      }
      data.last = spot;
    }
  }

}
class AccelerometerDataManager{
  double accelEuclidianVal = 0.0;

  double accelDataSeconds = 5;
  late CustomGraphData accelData;
  int pointsIdx = 0;
  bool fullSize = false;

  Butterworth butterworth = Butterworth();
  double lastFilterValue = 0.0;
  late double samplingHz;

  AccelerometerDataManager(Duration accelerometerSampling){
    samplingHz = 1000/accelerometerSampling.inMilliseconds;
    butterworth.lowPass(4, samplingHz, 2);
    accelData = CustomGraphData((samplingHz*accelDataSeconds).toInt());
  }

  List<FlSpot> get getPoints{
    return accelData.data;
  }

  double get3dEuclidianVal(double x, double y, double z){
    return sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
  }

  void addPoint(double val){
    accelData.addData(FlSpot(pointsIdx.toDouble(), val));
    pointsIdx++;
  }

  /*O algoritmo usado neste método e os valores de filtro são referentes ao seguinte artigo:
  Payette J, Vaussenat F, Cloutier SG. 
  Heart Rate Measurement Using the Built-In Triaxial Accelerometer from a Commercial Digital Writing Device. 
  Sensors. 2024; 24(7):2238. https://doi.org/10.3390/s24072238 
  Podendo ser encontrados na seção 2.2*/
  double evaluateData(UserAccelerometerEvent? accelerometerEvent){
    accelEuclidianVal = get3dEuclidianVal(accelerometerEvent!.x, accelerometerEvent.y, accelerometerEvent.z);
    lastFilterValue = butterworth.filter(accelEuclidianVal);
    return lastFilterValue;
  }

  double getAvg(){
    double dataSum = 0;
    for (FlSpot data in accelData.data){
      dataSum += data.y;
    }
    return dataSum/accelData.size.toDouble();
  }

  double getPulseDelta(){
    double pulseDeltaMs = 0;
    double dataAvg = getAvg();
    List<int> pulsePoints = <int>[];
    for (int i = 1; i < accelData.data.length; i++){
      if (accelData.data[i].y >= dataAvg && accelData.data[i-1].y < dataAvg){
        pulsePoints.add(i);
      }
    }
    if (pulsePoints.length > 1){
      for (int i = 1; i < pulsePoints.length; i++){
        pulseDeltaMs += (1000/samplingHz) * (pulsePoints[i] - pulsePoints[i-1]);
      }
      pulseDeltaMs /= pulsePoints.length-1;
    }
    //print(pulsePoints.length);
    return pulseDeltaMs/1000;
  }
  
}

/*class MyApp extends StatelessWidget {
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
}*/

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
  static const Duration _accelerometerSampling = Duration(milliseconds: 10);
  final _streamSubscription = <StreamSubscription<dynamic>>[];
  AccelerometerDataManager accelerometerDataManager = AccelerometerDataManager(_accelerometerSampling);


  @override
  initState(){
    super.initState();
    getAndroidModel();
    initAccelerometer();
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
          double managerVal = accelerometerDataManager.evaluateData(_accelerometerEvent);
          accelerometerDataManager.addPoint(managerVal);
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
              accelerometerDataManager.accelEuclidianVal.toString()
            ),
            const Text(
              "Last filter value"
            ),
            Text(
              accelerometerDataManager.lastFilterValue.toString()
            ),
            Text(
              accelerometerDataManager.getAvg().toString()
            ),
            Text(
              accelerometerDataManager.getPulseDelta().toString()
            ),
            Text(
              (60/accelerometerDataManager.getPulseDelta()).toString()
            ),
            const SizedBox(height: 45,),
            const HeartBeatAnimation(),
            const SizedBox(height: 90,),
            AspectRatio(
              aspectRatio: 2.0,
              child: LineChart(
                LineChartData(
                  //minX: 0,
                  //maxX: accelerometerDataManager.getPoints.length.toDouble(),
                  //minY: 0,
                  baselineY: 0,
                  maxY: 0.5,
                  clipData: const FlClipData(top: true, bottom: true, left: true, right: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: accelerometerDataManager.getPoints,
                      dotData: const FlDotData(
                        show: false,
                      ),
                    ),
                  ],
                  titlesData: const FlTitlesData(
                    show: false,
                  ),
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
