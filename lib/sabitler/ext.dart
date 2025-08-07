import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

const String arka_renk="006666";
const String api_key = "your_api_key";
const String site_link = "https://binersin.com/";
const String api_link = "https://binersin.com/panel/islemler/islem.php";
class renk extends Color{
  static int _donustur(String hexColor){
    hexColor=hexColor.toUpperCase().replaceAll("#", "");
    if(hexColor.length==6){
      hexColor="FF"+hexColor;
    }
    return int.parse(hexColor,radix: 16);
  }
  renk(final String renk_kodu):super(_donustur(renk_kodu));
}
alt_mesaj(BuildContext context, String mesaj,{int tur = 0}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj, style: GoogleFonts.quicksand(fontSize: 25),
          textAlign: TextAlign.center,),

        backgroundColor:tur==0? Colors.red:Colors.green,//hata mesaj rengi
        duration: Duration(seconds: 3),

      ));
}
bool oturum_kontrol()  {
  GetStorage box = GetStorage();
  var sonuc =  box.read("kullanici");


  if (sonuc == null || sonuc.toString().length <20) {
    return false;
  }else{
    return true;
  }
}