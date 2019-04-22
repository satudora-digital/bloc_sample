import '../Model/HealthProfile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HealthProfileRepository {
  static const String sharedPreferenceKey = 'healthProfile';

  // 本来はDataStoreのAPIを叩く形にするのがClean Architecture的には正しい気がするが、
  // 今回は命名に迷ってRepositoryという名前を使っているだけなのでそこまではしない。
  // また、今はSharedPreferenceを使うが、ここをFirestoreに変えたりするかも。
  Future<void> reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(sharedPreferenceKey);
  }

  void save(HealthProfile healthProfile) async {
    String additionalString = jsonEncode(healthProfile);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedHealthProfileStringList =
        prefs.getStringList(sharedPreferenceKey);
    if (storedHealthProfileStringList != null) {
      storedHealthProfileStringList.add(additionalString);
      await prefs.setStringList(
          sharedPreferenceKey, storedHealthProfileStringList);
    } else {
      await prefs.setStringList(sharedPreferenceKey, [additionalString]);
    }
  }

  Future<List<HealthProfile>> getAllHealthProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> allHealthProfileStringList =
        prefs.getStringList(sharedPreferenceKey);
    if(allHealthProfileStringList != null) {
      final List<HealthProfile> allHealthProfileList = allHealthProfileStringList
          .map((s) => HealthProfile.fromJson(jsonDecode(s)))
          .toList();
      for (var t in allHealthProfileList) {
        print(t.date);
        print(t.bodyTemperature);
        print(t.weight);
      }
      print(allHealthProfileList);
      return allHealthProfileList;
    }else{
      return null;
    }
  }

  Future<HealthProfile> getByDate(date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> allHealthProfileStringList =
        prefs.getStringList(sharedPreferenceKey);
    final List<HealthProfile> healthProfileList = allHealthProfileStringList
        .map((s) => HealthProfile.fromJson(jsonDecode(s)))
        .where((HealthProfile healthProfile) => healthProfile.date == date)
        .toList();
    if(healthProfileList.length > 1){
      Error();
    }else if (healthProfileList.length == 1){
      return healthProfileList[0];
    }else{
      return null;
    }
  }
}