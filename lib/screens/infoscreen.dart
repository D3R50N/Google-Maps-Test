// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({required this.marker, Key? key}) : super(key: key);
  final Marker marker;
  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  GoogleMapController? mapController;
  var topBarWidth = 100.0;

  double ratio = .7;

  var blue = Colors.blue;
  var white = Colors.white;

  var barColor;

  String infoText =
      "La pharmacie LIFE GARDEN est une pharmacie de garde, qui offre ses services de 08h-20h tous les samedis.";
  @override
  void initState() {
    super.initState();
    barColor = white;
  }

  @override
  Widget build(BuildContext context) {
    topBarWidth = MediaQuery.of(context).size.width * ratio;
    return Hero(
      tag: "marker_info",
      child: Scaffold(
        body: Stack(
          children: [
            body(context),
            Positioned(
              left: (MediaQuery.of(context).size.width - topBarWidth) / 2,
              child: Container(
                child: topBar(context),
              ),
              top: kToolbarHeight / 2,
            ),
          ],
        ),
      ),
    );
  }

  Column body(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: GoogleMap(
            zoomControlsEnabled: false,
            // mapType: MapType.terrain,
            markers: {
              widget.marker,
            },
            compassEnabled: true,
            onMapCreated: _onMapCreated,

            initialCameraPosition:
                CameraPosition(target: widget.marker.position, zoom: 15),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Informations",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Coordonnées : ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            widget.marker.position.longitude
                                    .toStringAsFixed(6) +
                                " LNG - " +
                                widget.marker.position.latitude
                                    .toStringAsFixed(6) +
                                " LAT",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description : ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            infoText,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.arrow_back_rounded),
                              Text("Retour"),
                            ],
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.navigation_rounded),
                              Text("Itinéraire"),
                            ],
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        )
      ],
    );
  }

  SizedBox topBar(BuildContext context) {
    topBarWidth = MediaQuery.of(context).size.width * ratio;
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: 35,
              width: topBarWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: barColor == white ? blue : white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
                color: barColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.location_on),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    border: InputBorder.none,
                    hintText: "Votre position actuelle",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Container(
              height: 35,
              width: topBarWidth * 4 / 4,
              decoration: BoxDecoration(
                border: Border.all(
                  color: barColor == white ? blue : white,
                  width: 2,
                ),
                color: barColor == white ? blue : white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  readOnly: true,
                  textAlign: TextAlign.right,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.location_searching_rounded),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                    border: InputBorder.none,
                    hintText: "Lieu destination",
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
