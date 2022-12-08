part of 'init_screen_bloc.dart';

abstract class InitScreenState {
  const InitScreenState();
}

class InitScreenInitial extends InitScreenState {}

class InitScreenLoadData extends InitScreenState {
  final List<double> data;
  InitScreenLoadData(this.data);
}

class InitScreenTools extends InitScreenState {
  double scale;
  double speed;
  double zoom;
  final List<double> data;
  final List<double> data2;
  double baselineX;
  bool loaded;
  bool file;
  double silverMax;
  FlSpot? initSpot;
  FlSpot? endSpot;
  int stateRule;

  InitScreenTools({
    required this.scale,
    required this.speed,
    required this.data,
    required this.data2,
    required this.zoom,
    required this.baselineX,
    required this.loaded,
    required this.file,
    required this.silverMax,
    this.initSpot,
    this.endSpot,
    this.stateRule = 0,
  });
}

class ArrhythmiaDetectionInitScreenState extends InitScreenState {
  ArrhythmiaResult result;

  ArrhythmiaDetectionInitScreenState({
    required this.result,
  });
}

class SelectBluetoothDeviceInitScreen extends InitScreenState {
  SelectBluetoothDeviceInitScreen();
}

class AddBluetoothDeviceInitScreenState extends InitScreenState {
  List<BlueScanResult> scanResults;
  AddBluetoothDeviceInitScreenState({required this.scanResults});
}

class ConnectingBluetoothDeviceInitScreenState extends InitScreenState {
  ConnectingBluetoothDeviceInitScreenState();
}

class DisconnectBluetoothDeviceInitScreenState extends InitScreenState {
  DisconnectBluetoothDeviceInitScreenState();
}

class ConnectedBluetoothDeviceInitScreenState extends InitScreenState {
  ConnectedBluetoothDeviceInitScreenState();
}
