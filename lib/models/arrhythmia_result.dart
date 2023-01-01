import 'dart:io';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/widget/signal_container.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ArrhythmiaResult {
  String nameFile; // name of the file
  String pathFolder; // path of the folder
  List<String> pathFiles = []; // the list of paths of the files
  int? result; // latest result
  int iter = 10; // number of iterations
  int? frequency; // frequency of the arrhythmia
  int position = 0; // position of the file

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
    final file = File("${pathFolder}${nameFile}.pdf");
    await file.writeAsBytes(await pdf.save());
    print("pdf saved");

    // liberate the memory
  }

  void addECG(List<double> ecg) {
    print("adding ecg");
    int createPosition = pathFiles.length;
    String pathFile = "$pathFolder${nameFile}_$createPosition.awecg";
    // add the ecg to the file
    File fileLoad = File(pathFile);
    // save the file
    fileLoad.writeAsStringSync(ecg.join(','));
    pathFiles.add(pathFile);
  }

  List<double> getData(int posInt) {
// load the file
    File fileLoad = File(pathFiles[posInt]);
    // load de file like a text
    String text = fileLoad.readAsStringSync();
    // split the text into a list of doubles separated by ','
    var fData = text.split(',').map((e) => double.parse(e)).toList();
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
