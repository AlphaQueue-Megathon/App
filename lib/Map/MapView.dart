import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as PP;
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:ui' as ui;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:round2/Map/UnorderedPath.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  GoogleMapController? _controller;

  Set<Marker> markers = Set(); //markers for google map
  List<LatLng> checkpoints = [];
  List<LatLng> chargingPoints = [];
  PP.PolylinePoints polylinePoints = PP.PolylinePoints();
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
  String googleAPIKey = FlutterConfig.get('GOOGLE_MAPS_API_KEY');
  String location = "Search Location";

  static const CameraPosition kIIIT = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(17.4549784, 78.3500765),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  addMarker(String id, LatLng L, String name, BitmapDescriptor marker) {
    markers.add(Marker(
        markerId: MarkerId(id),
        position: L,
        infoWindow: InfoWindow(title: name, snippet: 'A Checkpoint'),
        icon: marker));
    checkpoints.add(L);
    setState(() {});
  }

  addColorPolyLine(String mid, List<LatLng> polylineCoordinates, Color col) {
    PolylineId id = PolylineId(mid);
    Polyline polyline = Polyline(
      polylineId: id,
      color: col,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void searchPlace() async {
    var place = await PlacesAutocomplete.show(
        context: context,
        apiKey: googleAPIKey,
        mode: Mode.overlay,
        types: [],
        strictbounds: false);
    if (place != null) {
      setState(() {
        location = place.description.toString();
      });
    }
    final plist = GoogleMapsPlaces(
      apiKey: googleAPIKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    String placeid = place!.placeId ?? "0";
    final detail = await plist.getDetailsByPlaceId(placeid);
    final geometry = detail.result.geometry!;
    final lat = geometry.location.lat;
    final lang = geometry.location.lng;
    var newlatlang = LatLng(lat, lang);
    addMarker(geometry.location.toString(), newlatlang, detail.result.name,
        BitmapDescriptor.defaultMarker);
    _controller?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: newlatlang, zoom: 17)));
  }

  void hardcodedData() {
    BitmapDescriptor ctIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    addMarker("Mushroom rock road CT", const LatLng(17.450483, 78.345961),
        "Mushroom rock road CT", ctIcon);
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    hardcodedData();
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void computePath() async {
    var result = await unordered_path(checkpoints, chargingPoints, 100);
    var dist = result[0];
    var path = result[1];
    List<LatLng>? coordinates =
        (path as List).map((item) => item as LatLng).toList();
    List<LatLng> polylineCoordinates = [];
    for (int i = 0; i < coordinates!.length - 1; i++) {
      PP.PolylineResult res = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PP.PointLatLng(coordinates[i].latitude, coordinates[i].longitude),
        PP.PointLatLng(
            coordinates[i + 1].latitude, coordinates[i + 1].longitude),
        travelMode: PP.TravelMode.driving,
      );
      if (res.points.isNotEmpty) {
        res.points.forEach((PP.PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }
    addColorPolyLine(
        getRandomString(15), polylineCoordinates, Colors.deepPurpleAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 4),
        child: FloatingActionButton.extended(
          label: const Text('Checkpoint'),
          onPressed: () {
            searchPlace();
          },
          backgroundColor: Colors.amber,
          icon: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: kIIIT,
            markers: markers,
            polylines: Set<Polyline>.of(polylines.values),
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            compassEnabled: false,
            onMapCreated: (controller) {
              setState(() {
                _controller = controller;
              });
            },
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                computePath();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    Text(
                      'Confirm trip',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.time_to_leave,
                        size: 30,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
