
import 'package:flutter/material.dart';

class BlocContainer extends StatelessWidget {
  void pushPage(BuildContext BlocContext, BlocContainer container) {
    Navigator.of(BlocContext)
        .push(MaterialPageRoute(builder: (context) => container));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
