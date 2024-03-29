import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_app/WeatherBloc.dart';
import 'package:flutter_weather_app/WeatherModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app/WeatherRepo.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
      ),
      home: Scaffold (
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: BlocProvider(
          builder: (context) => WeatherBloc(WeatherRepo()),
          child:SearchPage(),
        ),
      )
    );
  }
}

class SearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    var cityController = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Center(
          child: Container(
            child: FlareActor("assets/WorldSpin.flr", fit: BoxFit.contain, animation: "roll",),
            height: 300,
            width: 300,
          )
        ),

        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state){
            if(state is WeatherIsNotSearched)
              return Container(
                padding: EdgeInsets.only(left: 32, right: 32,),
                child: Column(
                  children: <Widget>[
                    Text("Search Weather", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.white70),),
                    Text("Instantly", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w200, color: Colors.white70),),
                    SizedBox(height: 24,),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.white70,),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue,
                                style: BorderStyle.solid
                            )
                        ),

                        hintText: "City Name",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white70),
                    ),

                    SizedBox(height: 20,),
                    Container(
                        width: double.infinity,
                        height: 50,
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          onPressed: () {
                            weatherBloc.add(FetchWeather(cityController.text));
                          },
                          color: Colors.lightBlue,
                          child: Text("Search", style: TextStyle(color: Colors.white70, fontSize: 16),),
                        )
                    )
                  ],
                ),
              );
            else if(state is WeatherIsLoading)
              return Center(child: CircularProgressIndicator());
            else if(state is WeatherIsLoaded)
              return ShowWeather(state.getWeather, cityController.text);
            else
            return Text("Error", style: TextStyle(color: Colors.white70));
          }
        )
      ],
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 32, left: 32, top: 10),
      child: Column(
        children: <Widget>[
          Text(city,style: TextStyle(color: Colors.white70, fontSize: 30, fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),

          Text(weather.getTemp.round().toString()+"°F",style: TextStyle(color: Colors.white70, fontSize: 50),),
          Text("Temperature", style: TextStyle(color: Colors.white70, fontSize: 14),),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(weather.getMinTemp.round().toString()+"°F",style: TextStyle(color: Colors.white70, fontSize: 50),),
                  Text("Min Temperature",style: TextStyle(color: Colors.white70, fontSize: 14),),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(weather.getMaxTemp.round().toString()+"°F",style: TextStyle(color: Colors.white70, fontSize: 50),),
                  Text("Max Temperature", style: TextStyle(color: Colors.white70, fontSize: 14),),
                ],
              ),
            ],
          ),
          SizedBox(
            height:10,
          ),
        ],
    )
    );
  }
}