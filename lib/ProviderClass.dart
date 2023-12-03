import 'package:flutter/cupertino.dart';

class DataProvider extends ChangeNotifier{
  String? cityName;
  String? stationName;
  String? gateName;

  updateData(String _cityName,String _stationName,String _gateName){
    cityName=_cityName;
    stationName=_stationName;
    gateName=_gateName;
    notifyListeners();
  }
}