import 'package:awecg/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import '../bloc/init_screen/init_screen_bloc.dart';

class SelectMode extends StatelessWidget {
  const SelectMode({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(I18n().selectMode),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //Text(I18n().selectModeContent, style: TextStyle(fontSize: 18.dp)),
          Container(
            width: 20.w,
            child: Text(
              I18n().selectModeFile,
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 2.dp,
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<InitScreenBloc>(context)
                  .add(LoadECGFIleInitScreen());
              Navigator.of(context).pop();
            },
            child: Text(
              I18n().loadFile,
            ),
          ),
          SizedBox(
            height: 2.dp,
          ),
          Divider(),
          Container(
            width: 20.w,
            child: Text(
              I18n().selectModeBluetooth,
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
              I18n().connectToBluetooth,
            ),
          ),
          SizedBox(
            height: 2.dp,
          ),
          Divider(),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
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
