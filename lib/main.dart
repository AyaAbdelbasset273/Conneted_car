
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());
 class MyApp extends StatefulWidget {
   @override
   LocationPageState createState() => LocationPageState();
 }
 
 class LocationPageState extends State<MyApp> {
   Position _position;
   Position intialLocation;
   Position endLocation;
   double timeForPositiveAcceleration;
   double timeForNegativeAcceleration;
   StreamSubscription <Position> positionStream;
  
   
   Future<double> getDistance (intialLocation,endLocation)async{
     return( await Geolocator().distanceBetween(endLocation?.altitude,endLocation?.longitude, intialLocation?.latitude, intialLocation?.longitude)); 
   }
   @override
   void initState() {
    super.initState();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high,
    distanceFilter:10 );
    positionStream= Geolocator().getPositionStream(locationOptions).listen((Position position){
     setState (() {
       switch ((_position.speed*3.6).toStringAsPrecision(2)){
       case '10.0':
       {
       intialLocation=_position;
       }
       break;
       case '30.0':
       {
         endLocation=_position;
       }
       break;
       }
      
     });
    });
     
   }
   Future<void> getTime() async{
     if (endLocation!=null && intialLocation!=null)
     {
       
     timeForPositiveAcceleration= 20/(10/(await getDistance(endLocation, intialLocation)));
    
     timeForNegativeAcceleration= 20/(10/(await getDistance(endLocation, intialLocation)));
   }
   }
   @override
   void dispose(){
     super.dispose();
     positionStream.cancel();
   }
   @override
   Widget build(BuildContext context) {
     getTime();
     return new MaterialApp(
     home:new Scaffold(
       appBar: AppBar(title:Text( 'location app')),
        body:Column(
          
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
          children:<Widget>[
            Text(
              'Current Speed',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            Text(
              '${_position?.speed}',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.green[800],
                fontFamily: 'digital'
              ),
            ),
            Text(
              'km/h',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              'Time from 30 to 10 :',
            
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
           Text(
              '${timeForPositiveAcceleration?? 0}',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.green[800],
                fontFamily: 'digital'
              ),
            ),
            Text(
              'Second',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
           Text(
              'Time from 30 to 10 :',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
           Text(
              '${timeForNegativeAcceleration ?? 0}',
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.green[800],
                fontFamily: 'digital'
              ),
            ),
           Text(
              'Second',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ]
        )
     
     ));
   }
 }