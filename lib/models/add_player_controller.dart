import 'package:flutter/material.dart';

class AddPlayerContoller {
  TextEditingController txt;
  FocusNode focus;
  AddPlayerContoller() {
    txt = new TextEditingController();
    focus = new FocusNode();
  }
}
