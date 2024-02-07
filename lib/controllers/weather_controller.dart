import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;

import '../Widgets/Global_widgets.dart';
import '../models/weather_model.dart';

class WeatherController extends GetxController {
  @override
  void onInit() {
    _getLocationPermissionAndGetCurrentLocation();
    super.onInit();
  }

  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String apikey = "fc8d7048351e691809fdc416f294b8cc";
  late WeatherData weatherData = WeatherData(
    cod: '',
    message: 0,
    cnt: 0,
    list: [],
    city: City(
      id: 0,
      name: '',
      coord: Coord(lat: 0.0, lon: 0.0),
      country: '',
      population: 0,
      timezone: 0,
      sunrise: 0,
      sunset: 0,
    ),
  );

  Position? currentPosition;
  String currentCityName = '';
  //getting current location of user..
  Future<void> _getLocationPermissionAndGetCurrentLocation() async {
    PermissionStatus status = await Permission.location.status;

    if (status == PermissionStatus.granted) {
      await _getCurrentLocation();
    } else {
      if (await Permission.location.request().isGranted) {
        await _getCurrentLocation();
      } else {
        print('Location permission denied by user.');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition = position;
      update();

      await fetchWeatherData();
    } catch (e) {
      print('Error getting location: $e');
    }
  }

// get the data from the user of specific city or country..
  Future<void> fetchWeatherData({String? cityName, String? country}) async {
    try {
      String apiUrl;

      if (cityName != null) {
        if (country != null) {
          apiUrl = 'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$country&appid=$apikey';
        } else {
          apiUrl = 'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apikey';
        }

        currentCityName = cityName;
        update();
      } else if (currentPosition != null) {
        apiUrl = 'https://api.openweathermap.org/data/2.5/forecast?lat=${currentPosition!.latitude}&lon=${currentPosition!.longitude}&appid=$apikey';
        print("latitude${currentPosition!.latitude}");
        print("latitude${currentPosition!.longitude}");
      } else {
        print('Error: No location available.');
        return;
      }

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        weatherData = WeatherData.fromJson(data);
        update();
      } else if (response.statusCode == 401) {
        // Unauthorized - Incorrect or expired API key
        DialogUtils.showsDialog(title: "Error", message: "Please contact with administrator");
        throw Exception('Unauthorized: Incorrect or expired API key');
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// get the data from week days for weather
  List<String> getWeekDays() {
    List<String> days = [];

    if (currentPosition != null) {
      DateTime currentDate = DateTime.now();
      for (int i = 0; i < 7; i++) {
        DateTime nextDate = currentDate.add(Duration(days: i));
        String dayName = _getDayName(nextDate.weekday);
        days.add('$dayName, ${nextDate.day}/${nextDate.month}');
      }
    }

    return days;
  }

//convert the data into celcius
  double toCelsius(double kelvin) {
    return kelvin - 273.15;
  }

//convert the data into Fahrenheit
  double toFahrenheit(double kelvin) {
    return (toCelsius(kelvin) * 9 / 5) + 32;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
