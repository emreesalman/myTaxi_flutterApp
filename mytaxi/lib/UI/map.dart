
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:mytaxi/app/raised_button.dart';



class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  static const LatLng _center = const LatLng(39.0014668, 30.6872574);
  GoogleMapController myController;
  String searchAddr;
  LatLng _location;
  Position _currentPosition;

  var geoLocator=Geolocator();
  Completer<GoogleMapController> _completerGoogleMap=Completer();
  void localePosition() async{
    Position position= await Geolocator.getCurrentPosition();
    _currentPosition=position;
    LatLng latLngPosition=LatLng(position.latitude,position.longitude);
    _location=LatLng(position.latitude,position.longitude);
    cameraPositon(latLngPosition);
  }

  List<Marker> myMarker=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: GoogleMap(
              myLocationButtonEnabled: true,padding: EdgeInsets.only(top: 430),
              onMapCreated: onMapCreaded,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: CameraPosition(
                target:_center,
                zoom: 6.0,
              ),
              mapType: MapType.hybrid,
              markers: Set.from(myMarker),
              onTap: _handleTap,
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
        ),
          Positioned(
          bottom: 30.0,
          right: 75.0,
          left: 75.0,
            child:MyButton(
              textColor: Colors.black,
              buttonColor: Colors.yellow,
              onPressed: (){
                Navigator.pop(context,_location);
              },
              buttonIcon: Icon(Icons.where_to_vote_sharp),
              buttonText: "Konumu Seç",
            ),

          ),
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
              zoom: 20.0)));
    });
  }

  void _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker=[];
      myMarker.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          markerId:MarkerId(tappedPoint.toString()) ,
          position: tappedPoint,
        ),
      );
      _location=tappedPoint;
      cameraPositon(tappedPoint);
      print(_location);
      print(_location.longitude+10);
    });
  }
  void cameraPositon (LatLng targetP){
    CameraPosition cameraPosition=new CameraPosition(target: targetP,zoom: 18);
    myController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

}
}
