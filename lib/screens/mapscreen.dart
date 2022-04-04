// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // package à ajouter
import 'package:location/location.dart'; // package à ajouter
import 'package:maps_test/screens/infoscreen.dart';

/// objet de la classe Location fournie par le package location
var location = Location();

/// Une fonction asynchrone pour demander d'activer la localisation
void initServices() async {
  var services = await location.serviceEnabled();
  if (!services) services = await location.requestService();
  if (!services) return;
}

/// Une fonction future et asynchrone pour demander l'accès à la localisation
Future<void> initRequest() async {
  var services = await location.hasPermission();
  if (services == PermissionStatus.denied) {
    services = await location.requestPermission();
  }
  if (services != PermissionStatus.granted) return;
}

//L'écran principal
class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  ///Pour stocker la localisation et ne plus la redemander
  LocationData? ldata;

  ///La position de la caméra au démarrage de l'appli
  var initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 15,
  );

  ///Le marquer d'origine (Initialisé par défaut)
  Marker or = Marker(markerId: MarkerId("value"), onTap: () {});

  GoogleMapController? mapController;

  ///Représente le context actuel. Pour pouvoir accéder à l'écran InfoScreen
  /// (si on met un modal, ce ne sera plus) nécessaire
  late BuildContext mainContext;

  ///Vérifier si la carte est déjà rendue
  bool isRendered = false;

  @override
  void initState() {
    super.initState();
    initMap(); // initialiser la carte ( la fonction est totalement en bas)
  }

  @override
  void dispose() {
    super.dispose();
    //si on quitte la page, on arrête de rendre la carte
    mapController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isRendered) {
      setState(() {
        initMap();
        isRendered = true;
        //Si la carte n'est pas encore rendue, on la rend une seule fois
      });
    }
    setState(() {
      mainContext = context;
    });
    return Hero(
      tag: "marker_info",
      child: Scaffold(
        body: Stack(
          children: [
            if (mapController ==
                null) // si la carte n'est pas là, on affiche un indicateur de progress
              Center(child: CircularProgressIndicator()),
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              // mapType: MapType.terrain,
              markers: {
                or,
              },
              compassEnabled: true,
              onMapCreated: _onMapCreated,
              onLongPress: (LatLng l) {
                addMarker(l, context); // ajouter un marquer au clic
              },
              initialCameraPosition: initialCameraPosition,
            ),
            Positioned(
              child: Center(
                heightFactor: 3,
                child: SizedBox(
                  width: 300,
                  child: Card(
                    elevation: 3,
                    child: TextField(
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Rechercher",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //LES FONCTIONS

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  ///Initialiser la carte au début
  void initMap() {
    setState(() {
      mapController = null; //On annule le controller
    });

    if (ldata != null) {
      //si on avait récupéré la position
      //on initialise la caméra à la position trouvée
      setState(() {
        initialCameraPosition = CameraPosition(
          target: LatLng(ldata?.latitude ?? 0, ldata?.longitude ?? 0),
          zoom: 15,
        );
      });
    }

    initRequest().then((v) {
      initServices();

      /// Une fois la localisation acceptée, on cherche la postion actuelle et on stock sa valeur dans [ldata]
      location.getLocation().then((value) {
        LatLng curr = LatLng(value.latitude ?? 0, value.longitude ?? 0);
        setState(() {
          ldata = value;
          //on bouge la caméra et ..
          mapController?.moveCamera(
            CameraUpdate.newLatLng(
              curr,
            ),
          );
          addMarker(curr, mainContext); //.. on change le marqueur or
        });
      });
    });
  }

  ///Pour changer le marqueur [or]
  void addMarker(LatLng argument, BuildContext context) {
    setState(() {
      or = Marker(
          markerId: MarkerId("origin"),
          position: argument,
          // infoWindow: InfoWindow(title: "Vous êtes ici"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () {
            setState(() {
              isRendered =
                  false; // au clic, on réinitalise le isRendered ( à enlever si on met le modal)
            });
            if (context != null) {
              //aller vers l'autre écran (à enlever aussi)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return InfoScreen(
                      marker: or,
                    );
                  },
                ),
              );
            }
          });
    });
  }
}
