

import 'dart:async';


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';


class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  static const LatLng _center = const LatLng(39.0014668, 30.6872574);
  GoogleMapController myController;
  String searchAddr;

  Position _currentPosition;
  var geoLocator=Geolocator();
  Completer<GoogleMapController> _completerGoogleMap=Completer();

  void localePosition() async{
    Position position= await Geolocator.getCurrentPosition();
    _currentPosition=position;
    LatLng latLngPosition=LatLng(position.latitude,position.longitude);
    CameraPosition cameraPosition=new CameraPosition(target: latLngPosition,zoom: 500);
    debugPrint(latLngPosition.toString());
    myController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


  }

  @override
  Widget build(BuildContext context) {
  var temp=localePosition();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-100,
            width: double.infinity,
            child: GoogleMap(
              myLocationButtonEnabled: true,padding: EdgeInsets.only(top: 265),
              onMapCreated: onMapCreaded,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target:_center,
                zoom: 6.0,
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50,
              width: double.infinity ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Adres Giriniz',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0,top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: searchNavigate,
                    iconSize: 30.0,
                  ),
                ),
                onChanged: (value){
                  setState(() {
                    searchAddr=value;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void onMapCreaded(GoogleMapController controller) {
   _completerGoogleMap.complete(controller);
   myController=controller;
   localePosition();
  }

  void searchNavigate() {

    locationFromAddress(searchAddr).then((result){
      myController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target:
              LatLng(result[0].latitude, result[0].longitude),
              zoom: 15.0)));
    });
  }
}
