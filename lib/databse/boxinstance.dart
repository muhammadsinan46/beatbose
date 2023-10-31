import 'package:hive/hive.dart';
import 'package:beatboseapp/main.dart';

class InstanceBox{
  

  static Box ? _songbox;


  static Box getInstance(){
    _songbox ??= Hive.box(hiveMusic);
  return _songbox!;
  }
}

