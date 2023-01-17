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
  double baselineY;
  double silverMaxY;
  double silverMinY;
  bool loaded;
  bool file;
  double silverMax;
  bool pause;

  FlSpot? initSpot;
  FlSpot? endSpot;
  int stateRule;
  ArrhythmiaResult? result;

  InitScreenTools({
    required this.scale,
    required this.speed,
    required this.data,
    required this.data2,
    required this.zoom,
    required this.baselineX,
    required this.baselineY,
    required this.silverMaxY,
    required this.silverMinY,
    required this.loaded,
    required this.file,
    required this.silverMax,
    required this.pause,
    this.result,
    this.initSpot,
    this.endSpot,
    this.stateRule = 0,
  });
}

class ArrhythmiaDetectionInitScreenState extends InitScreenState {
  List<double> value;
  ArrhythmiaResult result;

  ArrhythmiaDetectionInitScreenState({
    required this.value,
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

class InitScreenError extends InitScreenState {
  final String message;
  InitScreenError(this.message);
}

class ShowNewProjectInitScreenState extends InitScreenState {
  ShowNewProjectInitScreenState();
}

class ProjectFolderInitScreenState extends InitScreenState {
  String folder;
  ProjectFolderInitScreenState({required this.folder});
}

class ProjectRandomNameInitScreenState extends InitScreenState {
  String name;
  ProjectRandomNameInitScreenState({required this.name});
}

class StartLoadingIntiScreenState extends InitScreenState {
  String? message;
  StartLoadingIntiScreenState({this.message});
}

class StopLoadingIntiScreenState extends InitScreenState {
  StopLoadingIntiScreenState();
}

class ShowPatientNewProjectInitScreenState extends InitScreenState {
  ShowPatientNewProjectInitScreenState();
}

class ShowSelectBluetoothDeviceInitScreenState extends InitScreenState {
  ShowSelectBluetoothDeviceInitScreenState();
}

class ShowOpenProjectInitScreenState extends InitScreenState {
  ShowOpenProjectInitScreenState();
}

class ShowPatientInformationInitScreenState extends InitScreenState {
  Patient patient;
  ShowPatientInformationInitScreenState({required this.patient});
}
