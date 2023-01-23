part of 'init_screen_bloc.dart';

@immutable
abstract class InitScreenEvent {}

class InitScreenInitialEvent extends InitScreenEvent {}

class LoadECGFIleInitScreen extends InitScreenEvent {}

class LoadECGBluetoothInitScreen extends InitScreenEvent {}

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

class ResetRulePointInitScreen extends InitScreenEvent {}

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

class ConnectedBluetoothDeviceInitScreen extends InitScreenEvent {}

class AddECGMonitorValue extends InitScreenEvent {
  List<double> value;
  AddECGMonitorValue({required this.value});
}

class CancelBluetoothDeviceInitScreen extends InitScreenEvent {}

class DisconnectBluetoothDeviceInitScreen extends InitScreenEvent {}

class NextECGDataInitScreen extends InitScreenEvent {}

class PreviousECGDataInitScreen extends InitScreenEvent {}

class changePlayECGBluetoothInitScreen extends InitScreenEvent {}

class newProjectInitScreen extends InitScreenEvent {}

class cancelNewProjectInitScreen extends InitScreenEvent {}

class newProjectPatientInformationInitScreen extends InitScreenEvent {}

class selectProjectFolderInitScreen extends InitScreenEvent {}

class randomProjectNameInitScreen extends InitScreenEvent {}

class validateProjectLocationInitScreen extends InitScreenEvent {
  String projectName;
  String projectFolder;
  validateProjectLocationInitScreen({
    required this.projectName,
    required this.projectFolder,
  });
}

class addPatientProjectInitScreen extends InitScreenEvent {
  Patient patient;
  addPatientProjectInitScreen({required this.patient});
}

class startBluetoothScanInitScreen extends InitScreenEvent {}

class errorBluetoothScanInitScreen extends InitScreenEvent {}

class openProjectInitScreen extends InitScreenEvent {}

class loadProjectInitScreen extends InitScreenEvent {
  String projectPath;
  loadProjectInitScreen({required this.projectPath});
}

class exportECGDataInitScreen extends InitScreenEvent {}

class patientInformationInitScreen extends InitScreenEvent {}

class medicalInformationInitScreen extends InitScreenEvent {}

class saveMedicalProfessionalInitScreen extends InitScreenEvent {
  MedicalProfessional medicalProfessional;
  saveMedicalProfessionalInitScreen({
    required this.medicalProfessional,
  });
}

class deleteMedicalProfessionalInitScreen extends InitScreenEvent {}
