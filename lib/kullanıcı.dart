class Kullanici {
  String? kulId;
  String? kulIsim;
  String? kulMail;
  String? kulSifre;
  String? kulTelefon;
  String? kulUnvan;
  String? kulYetki;
  String? kulLogo;
  String? ipAdresi;
  String? bakiye;
  String? sessionMail;


  Kullanici(
      {this.kulId,
        this.kulIsim,
        this.kulMail,
        this.kulSifre,
        this.kulTelefon,
        this.kulUnvan,
        this.kulYetki,
        this.kulLogo,
        this.ipAdresi,
        this.bakiye,
        this.sessionMail});




  Kullanici.fromJson(Map<String, dynamic> json) {
    kulId = json['kul_id'];
    kulIsim = json['kul_isim'];
    kulMail = json['kul_mail'];
    kulSifre = json['kul_sifre'];
    kulTelefon = json['kul_telefon'];
    kulUnvan = json['kul_unvan'];
    kulYetki = json['kul_yetki'];
    kulLogo = json['kul_logo'];
    ipAdresi = json['ip_adresi'];
    bakiye=json["bakiye"];
    sessionMail = json['session_mail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kul_id'] = this.kulId;
    data['kul_isim'] = this.kulIsim;
    data['kul_mail'] = this.kulMail;
    data['kul_sifre'] = this.kulSifre;
    data['kul_telefon'] = this.kulTelefon;
    data['kul_unvan'] = this.kulUnvan;
    data['kul_yetki'] = this.kulYetki;
    data['kul_logo'] = this.kulLogo;
    data['ip_adresi'] = this.ipAdresi;
    data['bakiye']=this.bakiye;
    data['session_mail'] = this.sessionMail;
    return data;
  }
}