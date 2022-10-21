import 'package:flutter/cupertino.dart';

class InitScreen extends StatelessWidget {
  const InitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Init Screen'),
      ),
      child: Center(
        child: Text('Init Screen'),
      ),
    );
  }
}
