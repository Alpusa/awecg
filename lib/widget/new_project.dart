import 'dart:io';

import 'package:awecg/generated/i18n.dart';
import 'package:awecg/repository/my_colors.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../bloc/init_screen/init_screen_bloc.dart';

class NewProject extends StatelessWidget {
  const NewProject({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(I18n().newProject),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
                    child: BlocBuilder<InitScreenBloc, InitScreenState>(
                      builder: (context, state) {
                        return TextField(
                          //disable editing text

                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: I18n().projectFolder,
                          ),
                        );
                      },
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
                    onPressed: () async {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          child: Text(I18n().next),
          onPressed: () {
            BlocProvider.of<InitScreenBloc>(context)
                .add(newProjectPatientInformationInitScreen());
            Navigator.of(context).pop();
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
