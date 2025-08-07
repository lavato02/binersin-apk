import 'package:musa/sabitler/ext.dart';
import 'package:musa/sabitler/tema.dart';
import 'package:musa/servis/oturum.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'anasayfa.dart';
import 'package:connectivity/connectivity.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  Tema tema = Tema();
  Oturum oturum = Oturum();
  String mail = "";
  String sifre = "";

  @override
  void initState() {
    super.initState();
    oturum_durum();
    checkInternetConnection();
  }

  oturum_durum() {
    bool x = oturum_kontrol();
    if (x) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
              (route) => false,
        );
      });
    }
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showNoInternetDialog();
    }
  }

  void showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('İnternet bağlantınız yok!'),
        content: Text('Lütfen internet bağlantınızı kontrol edin.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool sifre_gozukme = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: renk(arka_renk),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withOpacity(0),
                      width: 1,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: renk("2D2F3A"), //giriş sayfası çember etrafı
                        width: 15,
                      ),
                    ),
                    child: Icon(
                      Icons.login,
                      size: 50,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Giriş Yapın",
                    style: GoogleFonts.quicksand(
                        color: Colors.white38, fontSize: 30),
                  ),
                ),
                Container(
                  decoration: tema.inputBoxDec(),
                  margin: EdgeInsets.only(
                      top: 30, bottom: 10, right: 30, left: 30),
                  padding:
                  EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: TextFormField(
                    onChanged: (value) => mail = value,
                    decoration: tema.inputDec("E-Posta Adrsinizi Giriniz",
                        Icons.people_alt_outlined),
                    style: GoogleFonts.quicksand(color: Colors.black),
                  ),
                ),
                Container(
                  decoration: tema.inputBoxDec(),
                  margin: EdgeInsets.only(
                      top: 10, bottom: 10, right: 30, left: 30),
                  padding:
                  EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onChanged: (value) => sifre = value,
                          obscureText: true,
                          decoration: tema.inputDec(
                              "Şifrenizi Girin", Icons.vpn_key_outlined),
                          style: GoogleFonts.quicksand(
                              color: Colors.black, letterSpacing: 5),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (mail.length < 2 || !mail.contains("@")) {
                      alt_mesaj(context,
                          'Lütfen Geçerli Bir E-posta Giriniz.');
                    } else if (sifre.length < 3) {
                      alt_mesaj(context,
                          'Şifre Uzunluğu 2 Karakterden Fazla Olmalıdır.');
                    } else {
                      bool durum = await oturum.oturumac(context, mail, sifre);
                      if (durum) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AnaSayfa()),
                        );
                      }
                      GetStorage box = GetStorage();
                      print(box.read('kullanici'));
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 90, left: 90),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.greenAccent, Colors.black45],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(1, 6),
                          )
                        ]),
                    child: Center(
                      child: Text(
                        "GİRİŞ YAP",
                        style: GoogleFonts.quicksand(
                            color: Colors.white38, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 300),
                  child: Text(
                    "© 2024 Binersin. Tüm Hakları Saklıdır.",
                    style: GoogleFonts.quicksand(
                      color: Colors.white38,
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
