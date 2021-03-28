import 'package:flutter/cupertino.dart';

class Wrapper extends StatefulWidget {
  
  final Function onInit;
  final Widget child;

  Wrapper({@required this.onInit, @required this.child});

  @override
  WrapperState createState() => WrapperState();
  
}

class WrapperState extends State<Wrapper> {

  @override
  void initState() {
    if(widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
}