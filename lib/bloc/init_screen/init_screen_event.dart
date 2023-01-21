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

class newProjectInitScreen extends InitScreenEvent {
  newProjectInitScreen();
}

class cancelNewProjectInitScreen extends InitScreenEvent {
  cancelNewProjectInitScreen();
}

class newProjectPatientInformationInitScreen extends InitScreenEvent {
  newProjectPatientInformationInitScreen();
}

class selectProjectFolderInitScreen extends InitScreenEvent {
  selectProjectFolderInitScreen();
}

class randomProjectNameInitScreen extends InitScreenEvent {
  randomProjectNameInitScreen();
}

class validateProjectLocationInitScreen extends InitScreenEvent {
  String projectName;
  String projectFolder;
  validateProjectLocationInitScreen(
      {required this.projectName, required this.projectFolder});
}

class addPatientProjectInitScreen extends InitScreenEvent {
  Patient patient;
  addPatientProjectInitScreen({required this.patient});
}

class startBluetoothScanInitScreen extends InitScreenEvent {
  startBluetoothScanInitScreen();
}

class errorBluetoothScanInitScreen extends InitScreenEvent {
  errorBluetoothScanInitScreen();
}

class openProjectInitScreen extends InitScreenEvent {
  openProjectInitScreen();
}

class loadProjectInitScreen extends InitScreenEvent {
  String projectPath;
  loadProjectInitScreen({required this.projectPath});
}

class exportECGDataInitScreen extends InitScreenEvent {
  exportECGDataInitScreen();
}

class patientInformationInitScreen extends InitScreenEvent {
  patientInformationInitScreen();
}

class medicalInformationInitScreen extends InitScreenEvent {
  medicalInformationInitScreen();
}

class saveMedicalProfessionalInitScreen extends InitScreenEvent {
  MedicalProfessional medicalProfessional;
  saveMedicalProfessionalInitScreen({required this.medicalProfessional});
}

class deleteMedicalProfessionalInitScreen extends InitScreenEvent {
  deleteMedicalProfessionalInitScreen();
}
