import 'dart:io';

import 'package:awecg/repository/my_colors.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../bloc/init_screen/init_screen_bloc.dart';
import '../models/medical_professional.dart';
import '../models/patient.dart';
import '../repository/I18n.dart';

class MedicalProfessionalInformation extends StatelessWidget {
  MedicalProfessional medicalProfessional;
  bool loaded;
  MedicalProfessionalInformation({
    Key? key,
    required this.medicalProfessional,
    required this.loaded,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  TextEditingController _medicalProfessionalFullName = TextEditingController();
  TextEditingController _medicalProfessionalPhoneNumber =
      TextEditingController();
  TextEditingController _medicalProfessionalAddress = TextEditingController();
  TextEditingController _medicalProfessionalEmail = TextEditingController();
  // identify card
  TextEditingController _medicalProfessionalIdentityCard =
      TextEditingController();
  TextEditingController _medicalProfessionalSpecialty = TextEditingController();
  TextEditingController _medicalProfessionalPlace = TextEditingController();

  // create focus node for each text field
  final FocusNode _medicalProfessionalFullNameFocus = FocusNode();
  final FocusNode _medicalProfessionalPhoneNumberFocus = FocusNode();
  final FocusNode _medicalProfessionalAddressFocus = FocusNode();
  final FocusNode _medicalProfessionalEmailFocus = FocusNode();
  final FocusNode _medicalProfessionalIdentityCardFocus = FocusNode();
  final FocusNode _medicalProfessionalSpecialtyFocus = FocusNode();
  final FocusNode _medicalProfessionalPlaceFocus = FocusNode();
  final FocusNode _medicalProfessionalSaveButtonFocus = FocusNode();
  final FocusNode _medicalProfessionalClearButtonFocus = FocusNode();

  // create a Focus node to the next button
  final FocusNode _nextButtonFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _medicalProfessionalFullName.text = medicalProfessional.fullName;
    _medicalProfessionalPhoneNumber.text = medicalProfessional.phone;
    _medicalProfessionalAddress.text = medicalProfessional.address;
    _medicalProfessionalEmail.text = medicalProfessional.email;
    _medicalProfessionalIdentityCard.text = medicalProfessional.id;
    _medicalProfessionalSpecialty.text = medicalProfessional.specialty;
    _medicalProfessionalPlace.text = medicalProfessional.place;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: BlocBuilder<InitScreenBloc, InitScreenState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    I18n.translate("medicalProfessionalInformation")!,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  // full name
                  Container(
                    width: 20.w,
                    child: TextFormField(
                      focusNode: _medicalProfessionalFullNameFocus,
                      controller: _medicalProfessionalFullName,
                      obscureText: false,
                      readOnly: loaded,
                      decoration: InputDecoration(
                        labelText: I18n.translate("fullName")!,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return I18n.translate("fieldIsRequired")!;
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_medicalProfessionalPhoneNumberFocus),
                    ),
                  ),
                  // phone number
                  Container(
                    width: 20.w,
                    child: TextFormField(
                      focusNode: _medicalProfessionalPhoneNumberFocus,
                      controller: _medicalProfessionalPhoneNumber,
                      obscureText: false,
                      readOnly: loaded,
                      decoration: InputDecoration(
                        labelText: I18n.translate("phoneNumber")!,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return I18n.translate("fieldIsRequired")!;
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_medicalProfessionalAddressFocus),
                    ),
                  ),
                  // address
                  Container(
                    width: 20.w,
                    child: TextFormField(
                      focusNode: _medicalProfessionalAddressFocus,
                      controller: _medicalProfessionalAddress,
                      obscureText: false,
                      readOnly: loaded,
                      decoration: InputDecoration(
                        labelText: I18n.translate("address")!,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return I18n.translate("fieldIsRequired")!;
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_medicalProfessionalEmailFocus),
                    ),
                  ),
                  // email
                  Container(
                    width: 20.w,
                    child: TextFormField(
                      focusNode: _medicalProfessionalEmailFocus,
                      controller: _medicalProfessionalEmail,
                      obscureText: false,
                      readOnly: loaded,
                      decoration: InputDecoration(
                        labelText: I18n.translate("email")!,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return I18n.translate("fieldIsRequired")!;
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_medicalProfessionalIdentityCardFocus),
                    ),
                  ),
                  // identity card
                  Container(
                    width: 20.w,
                    child: TextFormField(
                      focusNode: _medicalProfessionalIdentityCardFocus,
                      controller: _medicalProfessionalIdentityCard,
                      obscureText: false,
                      readOnly: loaded,
                      decoration: InputDecoration(
                        labelText: I18n.translate("identityCard")!,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return I18n.translate("fieldIsRequired")!;
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_medicalProfessionalSpecialtyFocus),
                    ),
                  ),
                  // specialty
                  Container(
                    width: 20.w,
                    child: TextFormField(
                      focusNode: _medicalProfessionalSpecialtyFocus,
                      controller: _medicalProfessionalSpecialty,
                      obscureText: false,
                      readOnly: loaded,
                      decoration: InputDecoration(
                        labelText: I18n.translate("specialty")!,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return I18n.translate("fieldIsRequired")!;
                        }
                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_medicalProfessionalPlaceFocus),
                    ),
                  ),
                  // place
                  Container(
                    width: 20.w,
                    child: TextFormField(
                        focusNode: _medicalProfessionalPlaceFocus,
                        controller: _medicalProfessionalPlace,
                        obscureText: false,
                        readOnly: loaded,
                        decoration: InputDecoration(
                          labelText: I18n.translate("place")!,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return I18n.translate("fieldIsRequired")!;
                          }
                          return null;
                        },
                        onEditingComplete: () => !loaded
                            ? FocusScope.of(context).requestFocus(
                                _medicalProfessionalSaveButtonFocus)
                            : null),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        loaded
            ? const SizedBox(
                width: 0.0,
                height: 0.0,
              )
            : ElevatedButton(
                focusNode: _medicalProfessionalSaveButtonFocus,
                child: Text(I18n.translate("save")!),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    medicalProfessional.fullName =
                        _medicalProfessionalFullName.text;
                    medicalProfessional.phone =
                        _medicalProfessionalPhoneNumber.text;
                    medicalProfessional.address =
                        _medicalProfessionalAddress.text;
                    medicalProfessional.email = _medicalProfessionalEmail.text;
                    medicalProfessional.id =
                        _medicalProfessionalIdentityCard.text;
                    medicalProfessional.specialty =
                        _medicalProfessionalSpecialty.text;
                    medicalProfessional.place = _medicalProfessionalPlace.text;

                    BlocProvider.of<InitScreenBloc>(context).add(
                      saveMedicalProfessionalInitScreen(
                        medicalProfessional: medicalProfessional,
                      ),
                    );
                    Navigator.of(context).pop();
                  }
                },
              ),
        // clear button
        loaded
            ? const SizedBox(
                width: 0.0,
                height: 0.0,
              )
            : ElevatedButton(
                focusNode: _medicalProfessionalClearButtonFocus,
                child: Text(
                  I18n.translate("clear")!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.RedL,
                ),
                onPressed: () {
                  _medicalProfessionalFullName.clear();
                  _medicalProfessionalPhoneNumber.clear();
                  _medicalProfessionalAddress.clear();
                  _medicalProfessionalEmail.clear();
                  _medicalProfessionalIdentityCard.clear();
                  _medicalProfessionalSpecialty.clear();
                  _medicalProfessionalPlace.clear();

                  medicalProfessional.fullName = '';
                  medicalProfessional.phone = '';
                  medicalProfessional.address = '';
                  medicalProfessional.email = '';
                  medicalProfessional.id = '';
                  medicalProfessional.specialty = '';
                  medicalProfessional.place = '';

                  BlocProvider.of<InitScreenBloc>(context).add(
                    saveMedicalProfessionalInitScreen(
                      medicalProfessional: medicalProfessional,
                    ),
                  );
                  Navigator.of(context).pop();
                },
              ),
        ElevatedButton(
          child: Text(I18n.translate("cancel")!),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
