import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.422, -122.084),
          zoom: 15,
        ),
        onTap: (LatLng latLng) {
          setState(() {
            selectedLocation = latLng;
          });
        },
        markers: Set<Marker>.from([
          Marker(
            markerId: MarkerId('selectedLocation'),
            position: selectedLocation ?? LatLng(37.422, -122.084),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            // Konum seçildiğinde yapılacak işlemler
            Navigator.of(context).pop(selectedLocation);
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
