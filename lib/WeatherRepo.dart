import 'package:flutter_weather_app/WeatherModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepo{
  Future<WeatherModel> getWeather(String city) async{
    final result = await http.Client().get("https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=5b5662e0e361649bd13531d9295cd701");

    if(result.statusCode !=200)
      throw Exception();

    return parsedJson(result.body);
  }

  WeatherModel parsedJson(final response){
    final jsonDecoded = json.decode(response);

    final jsonWeather = jsonDecoded["main"];

    return WeatherModel.fromJson(jsonWeather);
  }
}