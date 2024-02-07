import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:masam_flutter_task/View/screens/weather_detail_page.dart';
import 'package:masam_flutter_task/controllers/weather_controller.dart';
import 'package:permission_handler/permission_handler.dart';


import '../../utils/constants.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherController>(
        init: WeatherController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: controller.isSearching
                  ? TextFormField(
                      controller: controller.searchController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Enter a city name',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintStyle: TextStyle(fontSize: 15),
                      ),
                      style: TextStyle(color: Colors.black),
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          controller.fetchWeatherData(cityName: value);
                          controller.isSearching = false;
                          controller.update();
                        }
                      },
                    )
                  : Text(controller.currentCityName.isNotEmpty ? controller.currentCityName : '5-Days Weather Forecast'),
              actions: [
                controller.isSearching
                    ? IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          controller.isSearching = false;
                          controller.searchController.clear();
                          controller.update();
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          controller.isSearching = true;
                          controller.update();
                        },
                      ),
              ],
            ),
            body: controller.weatherData.list.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        // Color(0xff5725e4).withOpacity(0.6),
                        // Color(0xff523370),
                        // Color(0xff040305),
                        ConstantColor.darkpurple,
                        ConstantColor.lightpurple,
                        ConstantColor.balck
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: ConstantColor.whiteColor,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "This Week",
                                  style: TextStyle(color: ConstantColor.whiteColor, fontSize: 25),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${controller.weatherData.city.name}",
                                  style: TextStyle(color: ConstantColor.whiteColor, fontSize: 20),
                                )
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {
                              final forecast = controller.weatherData.list[index];
                              final dayName = controller.getWeekDays()[index];
                              double temperatureCelsius = forecast.main.temp;
                              final city_data = controller.weatherData.city;
                              DateTime sunrise = DateTime.fromMillisecondsSinceEpoch(city_data.sunrise * 1000);
                              DateTime sunset = DateTime.fromMillisecondsSinceEpoch(city_data.sunset * 1000);
                              DateFormat timeFormat = DateFormat('hh:mm a');
                              String formattedSunrise = timeFormat.format(sunrise);
                              String formattedSunset = timeFormat.format(sunset);

                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => WeatherDetailPage(sunrise: formattedSunrise, sunset: formattedSunset, forecasting: forecast, temperatureCelsius: temperatureCelsius, dayname: dayName));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          dayName,
                                          style: TextStyle(fontSize: 15, color: ConstantColor.whiteColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.network(
                                          'https://openweathermap.org/img/wn/${forecast.weather[0].icon}.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          '${forecast.weather[0].main}',
                                          style: TextStyle(fontSize: 15, color: ConstantColor.whiteColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${controller.toCelsius(temperatureCelsius).toStringAsFixed(0)}°C / ${controller.toFahrenheit(temperatureCelsius).toStringAsFixed(0)}°F',
                                          style: TextStyle(fontSize: 15, color: ConstantColor.whiteColor),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Column(
                                children: [
                                  Divider(
                                    height: 0.1,
                                    color: ConstantColor.whiteColor.withOpacity(0.2),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              );
                            },
                            itemCount: controller.weatherData.list.length > 5 ? 5 : controller.weatherData.list.length,
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
