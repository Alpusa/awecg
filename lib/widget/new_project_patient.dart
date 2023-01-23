import 'dart:io';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/repository/my_colors.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../bloc/init_screen/init_screen_bloc.dart';
import '../models/patient.dart';

class NewProjectPatient extends StatelessWidget {
  NewProjectPatient({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _patientFullName = TextEditingController();
  TextEditingController _patientAge = TextEditingController();
  TextEditingController _patientPhoneNumber = TextEditingController();
  TextEditingController _patientAddress = TextEditingController();
  TextEditingController _patientEmail = TextEditingController();
  // identify card
  TextEditingController _patientIdentityCard = TextEditingController();

  // create focus node for each text field
  final FocusNode _patientFullNameFocus = FocusNode();
  final FocusNode _patientAgeFocus = FocusNode();
  final FocusNode _patientPhoneNumberFocus = FocusNode();
  final FocusNode _patientAddressFocus = FocusNode();
  final FocusNode _patientEmailFocus = FocusNode();
  final FocusNode _patientIdentityCardFocus = FocusNode();

  // create a Focus node to the next button
  final FocusNode _nextButtonFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                I18n.of(context).patientInformation,
                style: TextStyle(
                  fontSize: 25.dp,
                ),
              ),
              Container(
                width: 20.w,
                child: Text(
                  I18n.of(context).completeThePatientInformation +
                      ". " +
                      I18n.of(context).allFieldsAreRequired,
                  textAlign: TextAlign.justify,
                ),
              ),
              // full name
              Container(
                width: 20.w,
                child: TextFormField(
                  focusNode: _patientFullNameFocus,
                  controller: _patientFullName,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: I18n.of(context).fullName,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return I18n.of(context).fieldIsRequired;
                    }
                    return null;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_patientAgeFocus),
                ),
              ),
              // age
              Container(
                width: 20.w,
                child: TextFormField(
                  focusNode: _patientAgeFocus,
                  controller: _patientAge,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: I18n.of(context).age,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return I18n.of(context).fieldIsRequired;
                    }
                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(_patientPhoneNumberFocus),
                ),
              ),
              // phone number
              Container(
                width: 20.w,
                child: TextFormField(
                  focusNode: _patientPhoneNumberFocus,
                  controller: _patientPhoneNumber,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: I18n.of(context).phoneNumber,
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return I18n.of(context).fieldIsRequired;
                    }
                    return null;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_patientAddressFocus),
                ),
              ),
              // address
              Container(
                width: 20.w,
                child: TextFormField(
                  focusNode: _patientAddressFocus,
                  controller: _patientAddress,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: I18n.of(context).address,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return I18n.of(context).fieldIsRequired;
                    }
                    return null;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_patientEmailFocus),
                ),
              ),
              // email
              Container(
                width: 20.w,
                child: TextFormField(
                  focusNode: _patientEmailFocus,
                  controller: _patientEmail,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: I18n.of(context).email,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return I18n.of(context).fieldIsRequired;
                    }
                    return null;
                  },
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(_patientIdentityCardFocus),
                ),
              ),
              // identity card
              Container(
                width: 20.w,
                child: TextFormField(
                  focusNode: _patientIdentityCardFocus,
                  controller: _patientIdentityCard,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: I18n.of(context).identityCard,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return I18n.of(context).fieldIsRequired;
                    }
                    return null;
                  },
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_nextButtonFocus),
                ),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          focusNode: _nextButtonFocus,
          child: Text(I18n.of(context).next),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              BlocProvider.of<InitScreenBloc>(context).add(
                addPatientProjectInitScreen(
                    patient: Patient(
                  fullName: _patientFullName.text,
                  age: (_patientAge.text),
                  phone: _patientPhoneNumber.text,
                  address: _patientAddress.text,
                  email: _patientEmail.text,
                  id: _patientIdentityCard.text,
                )),
              );
              Navigator.of(context).pop();
            }
          },
        ),
        ElevatedButton(
          child: Text(I18n.of(context).cancel),
          onPressed: () {
            BlocProvider.of<InitScreenBloc>(context)
                .add(cancelNewProjectInitScreen());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
