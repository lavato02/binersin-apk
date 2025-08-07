import 'package:flutter/material.dart';

import 'ext.dart';

class Tema{
  inputDec(String hintText,IconData icon){
    return InputDecoration(
      border: InputBorder.none,
      hintText: hintText,
      prefixIcon: Icon(icon),
    );
  }
  inputBoxDec(){
    return BoxDecoration(
      color: renk("009966"),//E-posta ve şifer kutusu
      borderRadius: BorderRadius.circular(20),
    );
  }
}