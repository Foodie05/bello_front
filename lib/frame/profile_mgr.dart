import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

late final Box profile;
initProfileBox() async {
  if(kIsWeb){
    profile=await Hive.openBox('profile');
  }
  else{
    await Hive.initFlutter();//必须等待初始化才能继续
    profile=await Hive.openBox('profile');
  }
}
const String darkModeKey='isDarkMode';