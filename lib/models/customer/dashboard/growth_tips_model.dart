// class GrowthTipsModel {
//   List<String>? about;
//   List<String>? growing;
//   List<String>? plantnutrition;
//   List<String>? fertilizersuggestion;

//   GrowthTipsModel(
//       {this.about,
//       this.growing,
//       this.plantnutrition,
//       this.fertilizersuggestion});

//   GrowthTipsModel.fromJson(Map<String, dynamic> json) {
//     about = json['about'].cast<String>();
//     growing = json['growing'].cast<String>();
//     plantnutrition = json['plantnutrition'].cast<String>();
//     fertilizersuggestion = json['fertilizersuggestion'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['about'] = about;
//     data['growing'] = growing;
//     data['plantnutrition'] = plantnutrition;
//     data['fertilizersuggestion'] = fertilizersuggestion;
//     return data;
//   }
// }

class GrowthTipsModel {
  List<String>? about;
  List<String>? growing;
  List<String>? plantnutrition;
  List<String>? fertilizersuggestion;
  String? aboutImage;
  String? growingImage;
  String? nutritionImage;
  String? suggestionImage;

  GrowthTipsModel(
      {this.about,
      this.growing,
      this.plantnutrition,
      this.fertilizersuggestion,
      this.aboutImage,
      this.growingImage,
      this.nutritionImage,
      this.suggestionImage});

  GrowthTipsModel.fromJson(Map<String, dynamic> json) {
    about = json['about'].cast<String>();
    growing = json['growing'].cast<String>();
    plantnutrition = json['plantnutrition'].cast<String>();
    fertilizersuggestion = json['fertilizersuggestion'].cast<String>();
    aboutImage = json['aboutImage'];
    growingImage = json['growingImage'];
    nutritionImage = json['nutritionImage'];
    suggestionImage = json['suggestionImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['about'] = about;
    data['growing'] = growing;
    data['plantnutrition'] = plantnutrition;
    data['fertilizersuggestion'] = fertilizersuggestion;
    data['aboutImage'] = aboutImage;
    data['growingImage'] = growingImage;
    data['nutritionImage'] = nutritionImage;
    data['suggestionImage'] = suggestionImage;
    return data;
  }
}
