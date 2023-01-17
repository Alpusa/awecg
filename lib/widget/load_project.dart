import 'dart:io';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/repository/my_colors.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../bloc/init_screen/init_screen_bloc.dart';

class LoadProject extends StatelessWidget {
  LoadProject({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _projectFolderController = TextEditingController();
  FocusNode _projectFolderFocusNode = FocusNode();
  FocusNode _nextFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(I18n().openProject),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BlocListener<InitScreenBloc, InitScreenState>(
                listener: (context, state) {
                  if (state is ProjectFolderInitScreenState) {
                    _projectFolderController.text = state.folder;
                  }
                },
                child: Container(
                  height: 0.0,
                  width: 0.0,
                ),
              ),
              Container(
                width: 20.w,
                child: Text(
                  I18n().selectProjectFolder,
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                width: 20.w,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //disable editing text
                        focusNode: _projectFolderFocusNode,
                        controller: _projectFolderController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: I18n().projectFolder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return I18n().fieldIsRequired;
                          }
                          return null;
                        },
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_nextFocusNode),
                      ),
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          MyColors.BlueD,
                        ),
                      ),
                      icon: Icon(
                        Icons.search,
                      ),
                      onPressed: () async {
                        BlocProvider.of<InitScreenBloc>(context)
                            .add(selectProjectFolderInitScreen());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          focusNode: _nextFocusNode,
          child: Text(I18n().open),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              BlocProvider.of<InitScreenBloc>(context).add(
                  loadProjectInitScreen(
                      projectPath: _projectFolderController.text));
              Navigator.of(context).pop();
            }
          },
        ),
        ElevatedButton(
          child: Text(I18n().cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
