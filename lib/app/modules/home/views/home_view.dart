import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Obx(() =>GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            controller.currentLatitude.value,
            controller.currentLongitude.value,
          ),
          zoom: 13.5,
        ),
        polylines: {
          Polyline(
            polylineId: const PolylineId('overview_polyline'),
            color: Colors.blue,
            width: 5,
            points: controller.polylineCoordinates.value,
          ),
        },
        markers: {
          Marker(
            markerId: const MarkerId('currentLocation'),
            icon: controller.driverIcon.value,
            position: LatLng(
              controller.currentLatitude.value,
              controller.currentLongitude.value,
            ),
          ),
          Marker(
            markerId: const MarkerId('sourcePin'),
            position: controller.sourceLocation,
          ),
          Marker(
            markerId: const MarkerId('destPin'),
            position: controller.destination,
          ),
        },
        onMapCreated: (GoogleMapController newController) {
          controller.googleMapController.complete(newController);
        },
      )),
    );
  }
}
