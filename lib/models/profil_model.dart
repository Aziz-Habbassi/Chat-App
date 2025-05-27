class ProfilModel {
  String id;
  String name;
  String email;
  String profilpicurl;
  ProfilModel(this.id, this.name, this.email, this.profilpicurl);
  factory ProfilModel.fromJson(jsonDAta) {
    return ProfilModel(jsonDAta['id'], jsonDAta['name'], jsonDAta['email'],
        jsonDAta['profil_pic']);
  }
}
