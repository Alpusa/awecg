import 'dart:io';

import 'package:awecg/generated/i18n.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../bloc/init_screen/init_screen_bloc.dart';

class SelectMode extends StatelessWidget {
  const SelectMode({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(I18n.of(context).selectMode),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BlocListener<InitScreenBloc, InitScreenState>(
                listener: (context, state) {
                  if (state is InitScreenError) {
                    Navigator.pop(context);
                    EasyLoading.showError(state.message);
                  }
                },
                child: Container(height: 0.0, width: 0.0)),
            //Text(I18n.of(context).selectModeContent, style: TextStyle(fontSize: 18.dp)),
            Container(
              width: 20.w,
              child: Text(
                I18n.of(context).selectModeFile,
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 2.dp,
            ),
            ElevatedButton(
              onPressed: () async {
                BlocProvider.of<InitScreenBloc>(context)
                    .add(LoadECGFIleInitScreen());
                Navigator.of(context).pop();
              },
              child: Text(
                I18n.of(context).loadFile,
              ),
            ),
            SizedBox(
              height: 2.dp,
            ),
            Divider(),
            Container(
              width: 20.w,
              child: Text(
                I18n.of(context).selectModeBluetooth,
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(
              height: 2.dp,
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<InitScreenBloc>(context)
                    .add(LoadECGBluetoothInitScreen());
                //Navigator.of(context).pop();
              },
              child: Text(
                I18n.of(context).connectToBluetooth,
              ),
            ),
            SizedBox(
              height: 2.dp,
            ),
            Divider(),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          child: Text(I18n.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
