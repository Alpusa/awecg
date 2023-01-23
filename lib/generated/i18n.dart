import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes
// ignore_for_file: unnecessary_brace_in_string_interps

//WARNING: This file is automatically generated. DO NOT EDIT, all your changes would be lost.

typedef LocaleChangeCallback = void Function(Locale locale);

class I18n implements WidgetsLocalizations {

  const I18n();

  static Locale? _locale;

  static bool _shouldReload = false;

  static set locale(Locale newLocale) {
    _shouldReload = true;
    I18n._locale = newLocale;
  }

  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  /// function to be invoked when changing the language
  static LocaleChangeCallback onLocaleChanged = (Locale locale) {};

  static I18n of(BuildContext context) =>
    Localizations.of<I18n>(context, WidgetsLocalizations)!;

  @override
  TextDirection get textDirection => TextDirection.ltr;
  /// "Hello ${name}"
  String greetTo(String name) => "Hello ${name}";
  /// "ECG Signal"
  String get ecgSignal => "ECG Signal";
  /// "Scale"
  String get scale => "Scale";
  /// "Speed"
  String get speed => "Speed";
  /// "Frequency"
  String get frequency => "Frequency";
  /// "Change Scale"
  String get changeScale => "Change Scale";
  /// "Change Speed"
  String get changeSpeed => "Change Speed";
  /// "Reset Scale"
  String get resetScale => "Reset Scale";
  /// "Zoom In"
  String get zoomIn => "Zoom In";
  /// "Zoom Out"
  String get zoomOut => "Zoom Out";
  /// "Reset Zoom"
  String get resetZoom => "Reset Zoom";
  /// "Vertical Alignment"
  String get verticalAlignment => "Vertical Alignment";
  /// "Horizontal Alignment"
  String get horizontalAlignment => "Horizontal Alignment";
  /// "Time"
  String get time => "Time";
  /// "Voltage"
  String get voltage => "Voltage";
  /// "Amplitude"
  String get amplitude => "Amplitude";
  /// "Duration"
  String get duration => "Duration";
  /// "Voltage Difference"
  String get voltageDifference => "Voltage Difference";
  /// "Time Difference"
  String get timeDifference => "Time Difference";
  /// "Arrhythmia Detection"
  String get arrhythmiaDetection => "Arrhythmia Detection";
  /// "Normal"
  String get normal => "Normal";
  /// "Arrhythmia"
  String get arrhythmia => "Arrhythmia";
  /// "Noise"
  String get noise => "Noise";
  /// "Packs"
  String get packs => "Packs";
  /// "Pack"
  String get pack => "Pack";
  /// "Iter"
  String get iter => "Iter";
  /// "Iterations"
  String get iterations => "Iterations";
  /// "Tachycardia"
  String get tachycardia => "Tachycardia";
  /// "Bradycardia"
  String get bradycardia => "Bradycardia";
  /// "Select Mode"
  String get selectMode => "Select Mode";
  /// "Cancel"
  String get cancel => "Cancel";
  /// "OK"
  String get ok => "OK";
  /// "Select"
  String get select => "Select";
  /// "Load File"
  String get loadFile => "Load File";
  /// "Save File"
  String get saveFile => "Save File";
  /// "Save"
  String get save => "Save";
  /// "Load"
  String get load => "Load";
  /// "Clear"
  String get clear => "Clear";
  /// "Save As"
  String get saveAs => "Save As";
  /// "Load From"
  String get loadFrom => "Load From";
  /// "Save To"
  String get saveTo => "Save To";
  /// "Bluetooth"
  String get bluetooth => "Bluetooth";
  /// "Connect"
  String get connect => "Connect";
  /// "Disconnect"
  String get disconnect => "Disconnect";
  /// "Connected"
  String get connected => "Connected";
  /// "Disconnected"
  String get disconnected => "Disconnected";
  /// "Connected to ${name}"
  String connectedTo(String name) => "Connected to ${name}";
  /// "Disconnected from ${name}"
  String disconnectedFrom(String name) => "Disconnected from ${name}";
  /// "Connect to ${name}"
  String connectTo(String name) => "Connect to ${name}";
  /// "Disconnect from ${name}"
  String disconnectFrom(String name) => "Disconnect from ${name}";
  /// "Connect to Bluetooth"
  String get connectToBluetooth => "Connect to Bluetooth";
  /// "Disconnect from Bluetooth"
  String get disconnectFromBluetooth => "Disconnect from Bluetooth";
  /// "Select mode to start"
  String get selectModeContent => "Select mode to start";
  /// "If you want to load file, select \"Load File\" mode. The file extension must be \".awecg\"."
  String get selectModeFile => "If you want to load file, select \"Load File\" mode. The file extension must be \".awecg\".";
  /// "If you want to connect to bluetooth device, select \"Bluetooth\" mode and record ECG signal."
  String get selectModeBluetooth => "If you want to connect to bluetooth device, select \"Bluetooth\" mode and record ECG signal.";
  /// "Select Bluetooth Device"
  String get selectBluetoothDevice => "Select Bluetooth Device";
  /// "Address"
  String get address => "Address";
  /// "RSSI"
  String get rssi => "RSSI";
  /// "Error connecting to ${name}"
  String errorConnectingToDevice(String name) => "Error connecting to ${name}";
  /// "Next Signal"
  String get nextSignal => "Next Signal";
  /// "Previous Signal"
  String get previousSignal => "Previous Signal";
  /// "File Name"
  String get fileName => "File Name";
  /// "Project"
  String get project => "Project";
  /// "No Loaded"
  String get noLoaded => "No Loaded";
  /// "New Project"
  String get newProject => "New Project";
  /// "Open Project"
  String get openProject => "Open Project";
  /// "Open"
  String get open => "Open";
  /// "Edit Patient Information"
  String get editPatientInfrmation => "Edit Patient Information";
  /// "Edit Project Information"
  String get editProjectInformation => "Edit Project Information";
  /// "Medical Professional"
  String get medicalProfessional => "Medical Professional";
  /// "Medical Professional Information"
  String get medicalProfessionalInformation => "Medical Professional Information";
  /// "Export as PDF"
  String get exportAsPDF => "Export as PDF";
  /// "Exporting as PDF"
  String get exporingAsPDF => "Exporting as PDF";
  /// "This field is required"
  String get fieldIsRequired => "This field is required";
  /// "Fields are required"
  String get fieldsAreRequired => "Fields are required";
  /// "Loading"
  String get loading => "Loading";
  /// "Next"
  String get next => "Next";
  /// "Previous"
  String get previous => "Previous";
  /// "Create"
  String get create => "Create";
  /// "Select Project Folder"
  String get selectProjectFolder => "Select Project Folder";
  /// "Select the folder to save project"
  String get selectFolderToSaveProject => "Select the folder to save project";
  /// "Set Project Name"
  String get setProjectName => "Set Project Name";
  /// "Project Folder"
  String get projectFolder => "Project Folder";
  /// "Project Name"
  String get projectName => "Project Name";
  /// "Generate"
  String get generate => "Generate";
  /// "Folder does not exist"
  String get folderDoesNotExist => "Folder does not exist";
  /// "Project is already exist"
  String get projectIsAlreadyExist => "Project is already exist";
  /// "Patient Information"
  String get patientInformation => "Patient Information";
  /// "Full Name"
  String get fullName => "Full Name";
  /// "Age"
  String get age => "Age";
  /// "Phone Number"
  String get phoneNumber => "Phone Number";
  /// "Phone"
  String get phoneTitle => "Phone";
  /// "Email"
  String get email => "Email";
  /// "Identity Card"
  String get identityCard => "Identity Card";
  /// "Specialty"
  String get specialty => "Specialty";
  /// "Place"
  String get place => "Place";
  /// "Complete the patient information"
  String get completeThePatientInformation => "Complete the patient information";
  /// "All fields are required"
  String get allFieldsAreRequired => "All fields are required";
  /// "Error creating project"
  String get errorCreatingProject => "Error creating project";
  /// "Storage Permission Required"
  String get storagePermissionRequired => "Storage Permission Required";
  /// "Bluetooth Permission Required"
  String get bluetoothPermissionRequired => "Bluetooth Permission Required";
  /// "or"
  String get or => "or";
  /// "Bluetooth is disabled"
  String get bluetoothIsDisabled => "Bluetooth is disabled";
  /// "To use this function, first load or create new project"
  String get firstLoadOrCreateNewProjectToUseToUseThisFunction => "To use this function, first load or create new project";
  /// "Project is not valid"
  String get projectIsNotValid => "Project is not valid";
  /// "Project is broken"
  String get projectIsBroken => "Project is broken";
  /// "Disconnected and saved"
  String get disconnectedAndSaved => "Disconnected and saved";
  /// "Medical Information"
  String get medicalInformation => "Medical Information";
  /// "Date"
  String get date => "Date";
  /// "No Data"
  String get noData => "No Data";
}

class _I18n_en_US extends I18n {
  const _I18n_en_US();
  @override
  TextDirection get textDirection => TextDirection.ltr;
}

class GeneratedLocalizationsDelegate 
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const GeneratedLocalizationsDelegate();
  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("en", "US")
    ];
  }
  
  LocaleResolutionCallback resolution({Locale? fallback}) {
    return (Locale? locale, Iterable<Locale> supported) {
      if (null != locale && isSupported(locale)) {
        return locale;
      }
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    };
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    I18n._locale ??= locale;
    I18n._shouldReload = false;
    final String lang = I18n._locale != null ? I18n._locale.toString() : "";
    final String languageCode = I18n._locale != null ? I18n._locale!.languageCode : "";
    if ("en_US" == lang) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    }
    else if ("en" == languageCode) {
      return SynchronousFuture<WidgetsLocalizations>(const _I18n_en_US());
    }

    return SynchronousFuture<WidgetsLocalizations>(const I18n());
  }

  @override
  bool isSupported(Locale locale) {
    for (var i = 0; i < supportedLocales.length && locale != null; i++) {
      final l = supportedLocales[i];
      if (l.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => I18n._shouldReload;
}