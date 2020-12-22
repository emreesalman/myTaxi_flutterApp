import 'package:flutter/material.dart';

class Errors{
   static String showError(String errorCode){
    String error;
    switch(errorCode){
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return   "Mail Adresi Kullanilmakta, Lutfen Baska Bir Mail Adresi Kullaniniz.";

      default:
        return "Bir Hata Olustu";
    }
  }
}
