import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masam_flutter_task/controllers/weather_controller.dart';
import 'package:masam_flutter_task/models/weather_model.dart';


import '../../utils/constants.dart';

class WeatherDetailPage extends StatefulWidget {
  final Forecast forecasting;
  double temperatureCelsius;
  String dayname;
  String sunrise;
  String sunset;
  WeatherDetailPage({super.key, required this.forecasting, required this.temperatureCelsius, required this.dayname, required this.sunrise, required this.sunset});

  @override
  State<WeatherDetailPage> createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WeatherController>(
        init: WeatherController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
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
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: ConstantColor.whiteColor,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Image.asset("assets/Weather-sun-clouds-rain.svg.png"),
                    Text(
                      '${controller.toCelsius(widget.temperatureCelsius).toStringAsFixed(0)}°C ',
                      style: TextStyle(fontSize: 55, color: ConstantColor.whiteColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.forecasting.weather[0].description}',
                      style: TextStyle(fontSize: 20, color: ConstantColor.whiteColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${widget.dayname}',
                      style: TextStyle(fontSize: 20, color: ConstantColor.whiteColor),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.sunny,
                              color: Colors.orange.shade400,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sunrise",
                                  style: TextStyle(color: ConstantColor.whiteColor.withOpacity(0.8)),
                                ),
                                Text(
                                  "${widget.sunrise}",
                                  style: TextStyle(color: ConstantColor.whiteColor, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.sunny_snowing,
                              color: Colors.orange.shade400,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sunset",
                                  style: TextStyle(color: ConstantColor.whiteColor.withOpacity(0.8)),
                                ),
                                Text(
                                  "${widget.sunset}",
                                  style: TextStyle(color: ConstantColor.whiteColor, fontSize: 13),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
