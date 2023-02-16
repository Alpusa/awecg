import 'package:awecg/models/medical_professional.dart';
import 'package:awecg/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:pdf/widgets.dart' as pw;

import '../repository/I18n.dart';
import '../repository/my_colors.dart';

class InformationPage extends StatelessWidget {
  double height; // 3508 pixels
  double width; // 2480 pixels

  Patient patient;
  MedicalProfessional medicalProfessional;
  DateTime date;

  InformationPage(
      {required this.height,
      required this.width,
      required this.patient,
      required this.medicalProfessional,
      required this.date,
      Key? key})
      : super(key: key);

  double getHeight(double value) {
    return value * height / 100;
  }

  double getWidth(double value) {
    return value * width / 100;
  }

  @override
  Widget build(BuildContext context) {
    // create an medical information page like a table
    print('height: $height, width: $width');
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: MyColors.grayL,
          width: (2),
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  'lib/assets/icons/awecg.png',
                  width: getWidth(10),
                  height: getHeight(10),
                ),
                Column(
                  children: [
                    Text(
                      'AWECG',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      I18n.translate("medicalInformation")!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // show the date of the medical information
                Text(
                  '${I18n.translate("date")!}: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}',
                  style: TextStyle(
                    fontSize: (20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getHeight(3),
            ),
            Container(
              width: getWidth(100),
              decoration: BoxDecoration(
                color: MyColors.RedD,
                border: Border.all(
                  color: MyColors.grayL,
                  width: (2),
                ),
              ),
              child: Text(
                I18n.translate("patientInformation")!,
                style: TextStyle(
                  fontSize: (16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: getWidth(100),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("fullName")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        patient.fullName,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("age")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        patient.age,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("phoneTitle")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 23,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        patient.phone,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getWidth(100),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("address")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        patient.address,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),

                  // Identity Card
                  Expanded(
                    flex: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("identityCard")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 32,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        patient.id,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getWidth(100),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("email")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 88,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        patient.email,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getHeight(3),
            ),
            Container(
              width: getWidth(100),
              decoration: BoxDecoration(
                color: MyColors.RedD,
                border: Border.all(
                  color: MyColors.grayL,
                  width: (2),
                ),
              ),
              child: Text(
                I18n.translate("medicalProfessionalInformation")!,
                style: TextStyle(
                  fontSize: (16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: getWidth(100),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("fullName")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        medicalProfessional.fullName,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("specialty")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 34,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        medicalProfessional.specialty,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getWidth(100),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("email")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        medicalProfessional.email,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 14,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("phoneTitle")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 34,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        medicalProfessional.phone,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getWidth(100),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("address")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        medicalProfessional.address,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),

                  // Identity Card
                  Expanded(
                    flex: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("identityCard")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 32,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        medicalProfessional.id,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: getWidth(100),
              child: Row(
                children: [
                  Expanded(
                    flex: 12,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColors.BlueD,
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      child: Text(
                        '${I18n.translate("place")!}:',
                        style: TextStyle(
                          fontSize: (16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 88,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                      width: getWidth(90),
                      child: Text(
                        medicalProfessional.place,
                        style: TextStyle(
                          fontSize: (16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getHeight(10),
            ),
            SizedBox(
              // signature space
              width: getWidth(30),
              height: getHeight(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      //only bottom border
                      border: Border(
                        bottom: BorderSide(
                          color: MyColors.grayL,
                          width: (1),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    medicalProfessional.fullName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (16),
                    ),
                  ),
                  Text(
                    medicalProfessional.specialty,
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
