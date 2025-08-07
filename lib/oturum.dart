import 'dart:convert';
import 'package:musa/sabitler/ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:musa/kullanıcı.dart';

class Oturum {
  GetStorage box = GetStorage();
  Map<String, dynamic> gelen = {};

  Future<bool> oturumac(BuildContext context, String mail, String sifre) async {
    print(api_link + "?api_key=" + api_key);
    http.Response sonuc = await http.post(Uri.parse(api_link + "?api_key=" + api_key), body: {
      'oturumac': 'true',
      'kul_mail': mail,
      'kul_sifre': sifre,

    });

    if (sonuc.statusCode == 200) {
      try {
        Map<String, dynamic> gelenJson = jsonDecode(sonuc.body);

        if (gelenJson != null && gelenJson is Map<String, dynamic>) {
          gelen = gelenJson;

          if (gelen["bilgiler"] != null) {
            Kullanici kullanici = Kullanici.fromJson(gelen["bilgiler"]);
            print(kullanici.kulIsim);
            String kulMail = gelen["bilgiler"]["kul_mail"];
          } else {
            print("Hata: bilgiler alanı null");
          }

          print(gelen);

          if (gelen["durum"] == "ok") {
            alt_mesaj(context, "Oturum Açma İşlemi Başarılı", tur: 1);
            await box.write("kullanici", gelen["bilgiler"]);

            return true;
          } else if (gelen["durum"] == "no") {
            alt_mesaj(context, gelen["mesaj"], tur: 1);
            await box.write("clinician", gelen["bilgiler"]);
            return false;
          } else {
            alt_mesaj(context, gelen["mesaj"]);
            return false;
          }
        } else {
          print("JSON dönüşüm hatası: Geçersiz format");
          return false;
        }
      } catch (e) {
        print("JSON dönüşüm hatası: $e");
        return false;
      }
    } else {
      alt_mesaj(context,
          "İşleminizi şu anda gerçekleştiremiyoruz, Lütfen daha sonra tekrar deneyiniz");
      return false;
    }}}