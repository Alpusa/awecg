import 'dart:convert';
import 'dart:io';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/models/medical_professional.dart';
import 'package:awecg/widget/signal_container.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:encrypt/encrypt.dart' as enc;

import 'patient.dart';

class ArrhythmiaResult {
  String nameFile; // name of the file
  String pathFolder; // path of the folder
  List<String> pathFiles = []; // the list of paths of the files
  int? result; // latest result
  int iter = 10; // number of iterations
  int? frequency; // frequency of the arrhythmia
  int position = 0; // position of the file
  Patient? patient; // patient
  MedicalProfessional? medicalProfessional; // medical professional
  DateTime? date; // date

  ArrhythmiaResult({required this.nameFile, required this.pathFolder});

  Future<ArrhythmiaResult> init() async {
    result = null;
    frequency = null;
    // remove nameFile from pathFolder
    pathFolder = pathFolder.replaceAll(nameFile, "");
    // remove form the last _ to the end
    nameFile = nameFile.substring(0, nameFile.lastIndexOf("_"));
    // find in the folder the files with the name of the file
    print("pathFolder = ${pathFolder}" + " nameFile = ${nameFile}");

    Directory dir = Directory(pathFolder);
    print("dir = ${dir.path}");
    List<FileSystemEntity> files = dir.listSync(recursive: false);
    print(files);

    // find the files with the name of the file and the extension
    for (var element in files) {
      if (element.path.contains(RegExp(
          "^.*${nameFile}_([+-]?(?=\\.\\d|\\d)(?:\\d+)?(?:\\.?\\d*))(?:[eE]([+-]?\\d+))?awecg\$"))) {
        print("element.path = ${element.path}");
        pathFiles.add(element.path);
      }
    }
    pathFiles.sort((a, b) {
      int aInt =
          int.parse(a.substring(a.lastIndexOf("_") + 1, a.lastIndexOf(".")));
      int bInt =
          int.parse(b.substring(b.lastIndexOf("_") + 1, b.lastIndexOf(".")));

      return aInt.compareTo(bInt);
    });
    print("pathFiles = ${pathFiles}");

    return this;
  }

  int get getPosition {
    return position;
  }

  bool get isFinished {
    return (position == pathFiles.length - 1);
  }

  bool get isStarted {
    return (position > 0);
  }

  // sette and getter of the patient
  void setPatient(Patient patient) {
    this.patient = patient;
  }

  Patient? get getPatient {
    return patient;
  }

  // sette and getter of the medical professional
  void setMedicalProfessional(MedicalProfessional medicalProfessional) {
    this.medicalProfessional = medicalProfessional;
  }

  MedicalProfessional? get getMedicalProfessional {
    return medicalProfessional;
  }

  List<double> loadECG(int ecgPosition) {
    print("loading ecg position = ${ecgPosition}");
    position = ecgPosition;
    List<double> ecg = []; // the list of ecg values
    ecg = getData(ecgPosition);

    return ecg;
  }

  Future<void> exportPDF() async {
    //Create an instance of ScreenshotController
    ScreenshotController screenshotController = ScreenshotController();
    var pdf = pw.Document();
    int sizeBox = ((80 * 1) / (0.004 * 25)).floor();
    print("sizeBox = ${sizeBox}");
    List<double> ecgShow = [];
    for (var i = 0; i < pathFiles.length; i++) {
      print("i = ${i}");
      double speed = 25;
      double zoom = 1;
      bool show = true;
      ecgShow.addAll(getData(i));
      print("ecgShow.length = ${ecgShow.length}");
      if (ecgShow.length < sizeBox + 1) {
        show = false;
      }
      while (show) {
        var signalContainer = await screenshotController.captureFromWidget(
          MediaQuery(
            data: MediaQueryData(
              size: Size(3508, 2480),
              devicePixelRatio: 3,
            ),
            child: SignalContainer(
              height: 2480,
              width: 3508,
              ppi: 3,
              ecgData: ecgShow.sublist(0, sizeBox + 1),
              baselineX: 0,
            ),
          ),
          pixelRatio: 3,
        );
        ecgShow = ecgShow.sublist(sizeBox);
        var image = pw.MemoryImage(signalContainer);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            orientation: pw.PageOrientation.landscape,
            margin: pw.EdgeInsets.all(0),
            build: (context) {
              return pw.Image(image, fit: pw.BoxFit.fill);
            },
          ),
        );
        if (ecgShow.length < sizeBox + 1) {
          show = false;
        }
      }

      if (i == pathFiles.length - 1) {
        var signalContainer = await screenshotController.captureFromWidget(
          MediaQuery(
            data: MediaQueryData(
              size: Size(3508, 2480),
              devicePixelRatio: 3,
            ),
            child: SignalContainer(
              height: 2480,
              width: 3508,
              ppi: 3,
              ecgData: ecgShow,
              baselineX: 0,
            ),
          ),
          pixelRatio: 3,
        );
        ecgShow.clear();
        var image = pw.MemoryImage(signalContainer);
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            orientation: pw.PageOrientation.landscape,
            margin: pw.EdgeInsets.all(0),
            build: (context) {
              return pw.Image(image, fit: pw.BoxFit.fill);
            },
          ),
        );
      }
    }

    // save the pdf
    print("${pathFolder}/${nameFile}.pdf");
    final file = File("${pathFolder}/${nameFile}.pdf");
    await file.writeAsBytes(await pdf.save());
    print("pdf saved");

    // liberate the memory
  }

  Future<bool> createProject() async {
    // create the folder namded with the name of the project
    Directory dir = Directory(pathFolder);
    if (!dir.existsSync()) {
      dir.createSync();
    }
    // create the folder into folderpath named with the name of the project
    Directory dir2 = Directory("$pathFolder/$nameFile");
    if (!dir2.existsSync()) {
      dir2.createSync();
    }
    // create a folder into folderpath/nameproject named "data" to save the ecg files
    Directory dir3 = Directory("$pathFolder/$nameFile/data");
    if (!dir3.existsSync()) {
      dir3.createSync();
    }
    date = DateTime.now();
    // write an encripted file into folderpath/nameproject named nameproject.awecg to save the project information
    String pathFile = "$pathFolder/$nameFile/$nameFile.awecg";
    File fileLoad = File(pathFile);
    // create a json
    Map<String, dynamic> json = {
      "Project": nameFile,
      "date": date.toString(),
      "patient": patient!.toJson(),
      "medicalProfessional": medicalProfessional!.toJson(),
    };
    // convert the json to a string
    String jsonText = jsonEncode(json);
    // encript the string with the key and save the file
    final key = enc.Key.fromUtf8('Alejandro Pulido Saravia');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));

    fileLoad.writeAsStringSync(encrypter.encrypt(jsonText, iv: iv).base64);

    // check if the file was created, and check if the folder was created too and return true if all is ok and false if not
    if (fileLoad.existsSync() && dir.existsSync() && dir2.existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> validateProjectFolder(String proyectPathToCheck) async {
    // check if the folder exists
    Directory dir = Directory(proyectPathToCheck);
    if (!dir.existsSync()) {
      return false;
    }
    String nameFolder;
    if (Platform.isAndroid || Platform.isIOS) {
      // get the name of the folder
      nameFolder = proyectPathToCheck.split('/').last;
      print("nameFolder = $nameFolder");
    } else {
      // get the name of the folder
      nameFolder = proyectPathToCheck.split('\\').last;
      print("nameFolder = $nameFolder");
    }
    // check if the file exists
    String pathFile = "$proyectPathToCheck/$nameFolder.awecg";
    File fileLoad = File(pathFile);
    if (!fileLoad.existsSync()) {
      return false;
    }
    // read the file
    String fileText = fileLoad.readAsStringSync();
    // decrypt the file
    final key = enc.Key.fromUtf8('Alejandro Pulido Saravia');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final decrypted = encrypter.decrypt64(fileText, iv: iv);
    // convert the string to a json
    Map<String, dynamic> json = jsonDecode(decrypted);
    print("json = $json");
    // get the pathFiles
    String checkPathFilesJson = json["pathFiles"] ?? "";
    List<String> checkPathFiles = [];
    if (checkPathFilesJson.isNotEmpty) {
      // remove [ ]
      checkPathFilesJson =
          checkPathFilesJson.substring(1, checkPathFilesJson.length - 1);
      // remove spaces
      checkPathFilesJson = checkPathFilesJson.replaceAll(' ', '');
      checkPathFiles = checkPathFilesJson.split(',');
    } else {
      return false;
    }
    // check if the files exists
    for (var i = 0; i < checkPathFiles.length; i++) {
      String pathFile = "$proyectPathToCheck/data/${checkPathFiles[i]}";
      print("pathFile = $pathFile");
      File fileLoad = File(pathFile);
      if (!fileLoad.existsSync()) {
        return false;
      }
    }

    return true;
  }

  Future<bool> loadProject(String proyectPathToLoad) async {
    // check if the folder exists
    Directory dir = Directory(proyectPathToLoad);
    if (!dir.existsSync()) {
      return false;
    }
    String nameFolder;
    if (Platform.isAndroid || Platform.isIOS) {
      // get the name of the folder
      nameFolder = proyectPathToLoad.split('/').last;
      print("nameFolder = $nameFolder");
    } else {
      // get the name of the folder
      nameFolder = proyectPathToLoad.split('\\').last;
      print("nameFolder = $nameFolder");
    }
    // check if the file exists
    String pathFile = "$proyectPathToLoad/$nameFolder.awecg";
    pathFolder = proyectPathToLoad;

    File fileLoad = File(pathFile);
    if (!fileLoad.existsSync()) {
      return false;
    }
    // read the file
    String fileText = fileLoad.readAsStringSync();
    // decrypt the file
    final key = enc.Key.fromUtf8('Alejandro Pulido Saravia');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    final decrypted = encrypter.decrypt64(fileText, iv: iv);
    // convert the string to a json
    Map<String, dynamic> json = jsonDecode(decrypted);
    // get data from json
    nameFile = json["Project"];
    date = DateTime.parse(json["date"]);
    patient = Patient.fromJson(json["patient"]);
    medicalProfessional =
        MedicalProfessional.fromJson(json["medicalProfessional"]);
    // get the pathFiles
    String pathFilesJson = json["pathFiles"] ?? "";
    pathFiles = [];
    if (pathFilesJson.isNotEmpty) {
      // remove [ ]
      pathFilesJson = pathFilesJson.substring(1, pathFilesJson.length - 1);
      // remove spaces
      pathFilesJson = pathFilesJson.replaceAll(' ', '');
      pathFiles = pathFilesJson.split(',');
      print("pathFiles = $pathFiles");
    } else {
      return false;
    }
    return true;
  }

  void addECG(List<double> ecg) {
    print("adding ecg");
    final key = enc.Key.fromUtf8('Alejandro Pulido Saravia');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));

    int createPosition = pathFiles.length;
    String pathFile = "$pathFolder/$nameFile/data/$createPosition.datawecg";
    print("pathFile = $pathFile");
    // add the ecg to the file
    File fileLoad = File(pathFile);
    // save the file encrypted
    fileLoad.writeAsStringSync(encrypter.encrypt(ecg.join(','), iv: iv).base64);
    pathFiles.add("$createPosition.datawecg");

    String pathFileInfo = "$pathFolder/$nameFile/$nameFile.awecg";
    File fileLoadInfo = File(pathFileInfo);
    // create a json
    Map<String, dynamic> json = {
      "Project": nameFile,
      "date": date.toString(),
      "patient": patient!.toJson(),
      "medicalProfessional": medicalProfessional!.toJson(),
      "pathFiles": pathFiles.toString(),
      "modify": DateTime.now().toString(),
    };
    // convert the json to a string
    String jsonText = jsonEncode(json);
    // encript the string with the key and save the file

    fileLoadInfo.writeAsStringSync(encrypter.encrypt(jsonText, iv: iv).base64);
  }

  void reWriteFilesEncrypted() {
    print("encrypting ecg");
    final key = enc.Key.fromUtf8('Alejandro Pulido Saravia');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));

    // read and encrypt the files

    for (var i = 0; i < pathFiles.length; i++) {
      // load the file
      File fileLoad = File("$pathFolder/data/${pathFiles[i]}");
      // load de file like a text
      String text = fileLoad.readAsStringSync();
      // encrypt the text
      String textEncrypted = encrypter.encrypt(text, iv: iv).base64;
      // save the file
      fileLoad.writeAsStringSync(textEncrypted);
    }
  }

  List<double> getData(int posInt) {
// load the file
    File fileLoad = File("$pathFolder/data/${pathFiles[posInt]}");
    // load de file like a text
    String text = fileLoad.readAsStringSync();
    // decrypt the text
    final key = enc.Key.fromUtf8('Alejandro Pulido Saravia');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(key));
    String textDecrypted = encrypter.decrypt64(text, iv: iv);
    // split the text into a list of doubles separated by ','
    var fData = textDecrypted.split(',').map((e) => double.parse(e)).toList();
    return fData;
  }

  int get getLength {
    return (pathFiles.length);
  }

  /*
  // load all the files
    for (var element in pathFiles) {
      File fileLoad = await File(element);
      // load de file like a text
      String text = await fileLoad.readAsString();
      // split the text into a list of doubles separated by ','
      List<double> data = text.split(',').map((e) => double.parse(e)).toList();
    }
  */

  void addResult(int resultAdd) {
    print("resultAdd = ${resultAdd}");
    result = resultAdd >= 0 && resultAdd <= 2 ? resultAdd : null;
    //calculateResult();
  }

  /*void calculateResult() {
    int count_0 = 0;
    int count_1 = 0;
    int count_2 = 0;
    results.forEach((element) {
      if (element == 0) {
        count_0++;
      } else if (element == 1) {
        count_1++;
      } else if (element == 2) {
        count_2++;
      }
    });
    result = count_0 > count_1 && count_0 > count_2
        ? 0
        : count_1 > count_0 && count_1 > count_2
            ? 1
            : count_2 > count_0 && count_2 > count_1
                ? 2
                : 0;
  }*/

  void clear() {
    //results.clear();
    result = null;
  }

  /*get getResultValidation {
    if (result != null) {
      int count = 0;
      for (var element in results) {
        if (element == result) {
          count++;
        }
      }
      return count;
    }
    return null;
  }*/

  get getFrequencyClassify {
    if (frequency != null) {
      if (frequency! >= 0 && frequency! <= 60) {
        return I18n().bradycardia;
      } else if (frequency! >= 61 && frequency! <= 99) {
        return I18n().normal;
      } else if (frequency! >= 100) {
        return I18n().tachycardia;
      }
    }
    return null;
  }

  set setIter(int iter) {
    this.iter = iter;
  }

  set setFrequency(int? frequency) {
    this.frequency = frequency;
  }

  get getResult => result;
  get getIter => iter;
  get getFrequency => frequency;
}
