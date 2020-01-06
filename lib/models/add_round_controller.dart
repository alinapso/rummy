import 'package:flutter/material.dart';

class AddRoundControler {
  bool checkd;
  TextEditingController text;
  FocusNode focus;
  AddRoundControler() {
    text = new TextEditingController();
    focus = new FocusNode();
    checkd = false;
  }
}
