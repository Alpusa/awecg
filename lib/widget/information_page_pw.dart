import 'package:awecg/generated/i18n.dart';
import 'package:awecg/models/medical_professional.dart';
import 'package:awecg/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pdf/pdf.dart';
import 'dart:math' as math;
import 'package:pdf/widgets.dart' as pw;

import '../repository/my_colors.dart';

class InformationPagePW {
  double height; // 3508 pixels
  double width; // 2480 pixels
  double ppi; // 300 pixels per inch

  Patient patient;
  MedicalProfessional medicalProfessional;
  DateTime date;

  late Uint8List logo;

  InformationPagePW({
    required this.height,
    required this.width,
    required this.ppi,
    required this.patient,
    required this.medicalProfessional,
    required this.date,
  });

  Future<void> init() async {
    // load the logo

    logo = (await rootBundle.load('lib/assets/icons/awecg.png'))
        .buffer
        .asUint8List();
  }

  double getHeight(double value) {
    return value * height / 100;
  }

  double getWidth(double value) {
    return value * width / 100;
  }

  double getDp(double value) {
    return (math.log(width * height * ppi) / math.log(2) / 18 * value).abs();
  }

  pw.Widget build(pw.Context context) {
    // create an medical information page like a table

    // get the height of the page
    height = context.page.pageFormat.width;
    // get the width of the page
    width = context.page.pageFormat.height;
    print('height: $height, width: $width');
    return pw.Container(
      width: width,
      height: height,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(
          color: PdfColor.fromHex("666666FF"),
          width: (2),
        ),
      ),
      child: pw.SizedBox(
        width: width,
        height: height,
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Image(
                    pw.MemoryImage(
                      logo,
                    ),
                    width: getWidth(10),
                    height: getHeight(10),
                  ),
                ),

                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        'AWECG',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 30,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        const I18n().medicalInformation,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // show the date of the medical information.
                pw.Expanded(
                  flex: 1,
                  child: pw.Text(
                    '${const I18n().date}: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: (20),
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: getHeight(3),
            ),
            pw.Container(
              width: getWidth(100),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex("E8737899"),
                border: pw.Border.all(
                  color: PdfColor.fromHex("666666FF"),
                  width: (2),
                ),
              ),
              child: pw.Text(
                const I18n().patientInformation,
                style: pw.TextStyle(
                  fontSize: (16),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: getWidth(100),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 12,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().fullName}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 40,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        patient.fullName.isEmpty
                            ? I18n().noData
                            : patient.fullName,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 6,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().age}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 9,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        patient.age.isEmpty ? I18n().noData : patient.age,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 10,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().phoneTitle}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 23,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        patient.phone.isEmpty ? I18n().noData : patient.phone,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(
              width: getWidth(100),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 12,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().address}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 40,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        patient.address.isEmpty
                            ? I18n().noData
                            : patient.address,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),

                  // Identity Card
                  pw.Expanded(
                    flex: 16,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().identityCard}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  pw.Expanded(
                    flex: 32,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        patient.id.isEmpty ? I18n().noData : patient.id,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(
              width: getWidth(100),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 12,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().email}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 88,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        patient.email.isEmpty ? I18n().noData : patient.email,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(
              height: getHeight(3),
            ),
            pw.Container(
              width: getWidth(100),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex("E8737899"),
                border: pw.Border.all(
                  color: PdfColor.fromHex("666666FF"),
                  width: (2),
                ),
              ),
              child: pw.Text(
                const I18n().medicalProfessionalInformation,
                style: pw.TextStyle(
                  fontSize: (16),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(
              width: getWidth(100),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 12,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().fullName}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 40,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        medicalProfessional.fullName.isEmpty
                            ? I18n().noData
                            : medicalProfessional.fullName,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 14,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().specialty}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 34,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        medicalProfessional.specialty.isEmpty
                            ? I18n().noData
                            : medicalProfessional.specialty,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(
              width: getWidth(100),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 12,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().email}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 40,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        medicalProfessional.email.isEmpty
                            ? I18n().noData
                            : medicalProfessional.email,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 14,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().phoneTitle}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 34,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        medicalProfessional.phone.isEmpty
                            ? I18n().noData
                            : medicalProfessional.phone,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(
              width: getWidth(100),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 12,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().address}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 40,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        medicalProfessional.address.isEmpty
                            ? I18n().noData
                            : medicalProfessional.address,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),

                  // Identity Card
                  pw.Expanded(
                    flex: 16,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().identityCard}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  pw.Expanded(
                    flex: 32,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        medicalProfessional.id.isEmpty
                            ? I18n().noData
                            : medicalProfessional.id,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(
              width: getWidth(100),
              child: pw.Row(
                children: [
                  pw.Expanded(
                    flex: 12,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("74DBE899"),
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      child: pw.Text(
                        '${const I18n().place}:',
                        style: pw.TextStyle(
                          fontSize: (16),
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.Expanded(
                    flex: 88,
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                      width: getWidth(90),
                      child: pw.Text(
                        medicalProfessional.place.isEmpty
                            ? I18n().noData
                            : medicalProfessional.place,
                        style: const pw.TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(
              height: getHeight(10),
            ),
            pw.SizedBox(
              // signature space
              width: getWidth(30),
              height: getHeight(30),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      //only bottom border
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColor.fromHex("666666FF"),
                          width: (1),
                        ),
                      ),
                    ),
                  ),
                  pw.Text(
                    medicalProfessional.fullName.isEmpty
                        ? I18n().noData
                        : medicalProfessional.fullName,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: (16),
                    ),
                  ),
                  pw.Text(
                    medicalProfessional.specialty.isEmpty
                        ? I18n().noData
                        : medicalProfessional.specialty,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: (16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
