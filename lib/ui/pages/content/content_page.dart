//import 'package:geolocator/geolocator.dart';
import 'package:gps_tracker/domain/models/location.dart';
//import 'package:gps_tracker/domain/use_cases/location_manager.dart';
import 'package:gps_tracker/ui/controllers/gps.dart';
import 'package:gps_tracker/ui/controllers/location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentPage extends GetView<LocationController> {
  late final GpsController gpsController = Get.find();

  ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GPS Tracker"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final location = await gpsController.currentLocation;
                        final accuracy = await gpsController.locationAccuracy;
                        controller.saveLocation(
                            location: TrackedLocation(
                                latitude: location.latitude,
                                longitude: location.longitude,
                                precision: accuracy.name,
                                timestamp: DateTime.now()));
                      },
                      child: const Text("Registrar Ubicacion"),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: controller.locations.length,
                        itemBuilder: (context, index) {
                          final location = controller.locations[index];
                          return Card(
                            child: ListTile(
                              isThreeLine: true,
                              leading: Icon(
                                Icons.gps_fixed_rounded,
                                color: Colors.amber[300],
                              ),
                              title: Text(
                                  '${location.latitude}, ${location.longitude}'),
                              subtitle: Text(
                                  'Fecha: ${location.timestamp.toIso8601String()}\n${location.precision.toUpperCase()}'),
                              trailing: IconButton(
                                onPressed: () {
                                  controller.deleteLocation(location: location);
                                },
                                icon: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        await controller.deleteAll();
                      },
                      child: const Text("Eliminar Todos"),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
