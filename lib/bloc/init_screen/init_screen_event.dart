part of 'init_screen_bloc.dart';

@immutable
abstract class InitScreenEvent {}

class InitScreenInitialEvent extends InitScreenEvent {}

class LoadECGFIleInitScreen extends InitScreenEvent {
  LoadECGFIleInitScreen();
}

class LoadECGBluetoothInitScreen extends InitScreenEvent {
  LoadECGBluetoothInitScreen();
}

class ChangeScaleInitScreen extends InitScreenEvent {}

class ChangeSpeedInitScreen extends InitScreenEvent {}

class ResetScalesInitScreen extends InitScreenEvent {}

class ZoomInInitScreen extends InitScreenEvent {}

class ZoomOutInitScreen extends InitScreenEvent {}

class ResetZoomInitScreen extends InitScreenEvent {}

class ChangeBaselineXInitScreen extends InitScreenEvent {
  double baselineX;
  ChangeBaselineXInitScreen({required this.baselineX});
}

class ChangeBaselineYInitScreen extends InitScreenEvent {
  double baselineY;
  ChangeBaselineYInitScreen({required this.baselineY});
}

class SetRulePointInitScreen extends InitScreenEvent {
  FlSpot? spot;
  SetRulePointInitScreen({required this.spot});
}

class ResetRulePointInitScreen extends InitScreenEvent {
  ResetRulePointInitScreen();
}

class evaluateDataInitScreen extends InitScreenEvent {
  List<double> data;
  evaluateDataInitScreen({required this.data});
}

class AddBluetoothDevice extends InitScreenEvent {
  BlueScanResult scanResult;
  AddBluetoothDevice({required this.scanResult});
}

class ConnectBluetoothDeviceInitScreen extends InitScreenEvent {
  String deviceId;
  ConnectBluetoothDeviceInitScreen({required this.deviceId});
}

class ConnectedBluetoothDeviceInitScreen extends InitScreenEvent {
  ConnectedBluetoothDeviceInitScreen();
}

class AddECGMonitorValue extends InitScreenEvent {
  List<double> value;
  AddECGMonitorValue({required this.value});
}

class CancelBluetoothDeviceInitScreen extends InitScreenEvent {
  CancelBluetoothDeviceInitScreen();
}

class DisconnectBluetoothDeviceInitScreen extends InitScreenEvent {
  DisconnectBluetoothDeviceInitScreen();
}

class NextECGDataInitScreen extends InitScreenEvent {
  NextECGDataInitScreen();
}

class PreviousECGDataInitScreen extends InitScreenEvent {
  PreviousECGDataInitScreen();
}

class changePlayECGBluetoothInitScreen extends InitScreenEvent {
  changePlayECGBluetoothInitScreen();
}

class exportECGDataInitScreen extends InitScreenEvent {
  exportECGDataInitScreen();
}

class newProjectInitScreen extends InitScreenEvent {
  newProjectInitScreen();
}

class newProjectPatientInformationInitScreen extends InitScreenEvent {
  newProjectPatientInformationInitScreen();
}
