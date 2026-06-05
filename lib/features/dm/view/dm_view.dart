import 'package:flutter/material.dart';

class DmView extends StatefulWidget {
  const DmView({super.key});

  @override
  State<DmView> createState() => _DmViewState();
}

class _DmViewState extends State<DmView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('DmView')));
  }
}
