
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
    
   double  timeForPositiveAcceleration;
   double timeForNegativeAcceleration;
   StreamSubscription <Position> positionStream ;
   double speed;
   bool flag;
   Stopwatch timer=new Stopwatch(); 
   @override
   void initState() {
    super.initState();
    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high,
    distanceFilter:10 );
    positionStream= Geolocator().getPositionStream(locationOptions).listen((Position position){
     setState (() {
       _position=position;
       speed=(_position?.speed??0)*3.6;
       if(speed.round()>=10 &&speed.round()<30)
        {
         timer.start();
        }
        
       else if(speed.round()>=30)
        { 
          setState(() {
            
            timeForPositiveAcceleration=(timer.elapsed.inSeconds) as double;
          });
          timer.reset();
          timer.start();
         
        }
      
       else if(speed<=10)
              {
            setState(() {
           timeForNegativeAcceleration=(timer.elapsed.inSeconds) as double;
         });
        }
      timer.stop();
     });
    });
     
   }
   
   @override
   void dispose(){
     super.dispose();
     positionStream.cancel();
   }
   @override
   Widget build(BuildContext context) {
    
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
              '${speed??0.0}',
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
              'Time from 10 to 30 :',
            
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