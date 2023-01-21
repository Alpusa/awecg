import 'package:awecg/generated/i18n.dart';
import 'package:awecg/repository/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:quick_blue/quick_blue.dart';

import '../bloc/init_screen/init_screen_bloc.dart';

class SelectBluetoothDevice extends StatelessWidget {
  List<BlueScanResult> scanResults = [];
  SelectBluetoothDevice({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AlertDialog(
      title: Text(I18n().selectBluetoothDevice),
      content: Scaffold(
        body: Container(
          //width: 20.w,
          child: BlocBuilder<InitScreenBloc, InitScreenState>(
            builder: (context, state) {
              if (state is AddBluetoothDeviceInitScreenState) {
                scanResults = state.scanResults;
              }
              if (state is ConnectingBluetoothDeviceInitScreenState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: scanResults
                    .map(
                      (e) => Card(
                        //color: Colors.black12,
                        elevation: 6,
                        child: ListTile(
                          hoverColor: MyColors.BlueL,
                          style: ListTileStyle.list,
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.dp),
                          ),
                          title: Row(
                            children: [
                              //Text("${I18n().address}: "),
                              // show the name separated with ":" when count 2 caracter

                              Text(
                                  e.name /*.replaceAllMapped(
                                  RegExp(
                                    r"[a-zA-Z0-9]{2}",
                                  ), (match) {
                                return "${(match.group(0).toString()).toUpperCase()}${e.device.name.indexOf(match.group(0).toString()) == e.device.name.length - 2 ? "" : ":"}";
                              }).toString()*/
                                  ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text("${I18n().rssi}: "),
                              Text("${e.rssi}"),
                            ],
                          ),
                          onTap: () {
                            print("onTap ${e.name}");
                            BlocProvider.of<InitScreenBloc>(context).add(
                                ConnectBluetoothDeviceInitScreen(
                                    deviceId: e.deviceId));
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            buildWhen: (previous, current) =>
                current is AddBluetoothDeviceInitScreenState ||
                current is ConnectingBluetoothDeviceInitScreenState,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<InitScreenBloc>(context)
                .add(startBluetoothScanInitScreen());
          },
          child: Icon(Icons.search),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          child: Text(I18n().cancel),
          onPressed: () {
            BlocProvider.of<InitScreenBloc>(context)
                .add(CancelBluetoothDeviceInitScreen());
            BlocProvider.of<InitScreenBloc>(context)
                .add(cancelNewProjectInitScreen());
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
