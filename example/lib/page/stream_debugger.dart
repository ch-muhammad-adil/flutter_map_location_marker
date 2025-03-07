import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';

class StreamDebugger extends StatefulWidget {
  @override
  State<StreamDebugger> createState() => _StreamDebuggerState();
}

class _StreamDebuggerState extends State<StreamDebugger> {
  late Stream<LocationMarkerPosition> stream;
  LocationMarkerPosition locationMarkerPosition = LocationMarkerPosition(
    latitude: 0,
    longitude: 0,
    accuracy: 20000,
  );

  @override
  void initState() {
    super.initState();
    stream = Stream.value(locationMarkerPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stream Debugger'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(0, 0),
          zoom: 8,
          minZoom: 0,
          maxZoom: 19,
        ),
        nonRotatedChildren: [
          Positioned(
            right: 20,
            bottom: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    final random = Random();
                    setState(() {
                      stream = Stream.periodic(const Duration(seconds: 1), (_) {
                        return locationMarkerPosition = LocationMarkerPosition(
                          latitude: locationMarkerPosition.latitude - 0.05,
                          longitude: locationMarkerPosition.longitude,
                          accuracy: random.nextDouble() * 80000 + 20000,
                        );
                      });
                    });
                  },
                  heroTag: null,
                  child: const Icon(
                    Icons.vertical_align_bottom,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                  onPressed: () {
                    final random = Random();
                    setState(() {
                      stream = Stream.periodic(const Duration(seconds: 2), (_) {
                        return locationMarkerPosition = LocationMarkerPosition(
                          latitude: locationMarkerPosition.latitude + 0.1,
                          longitude: locationMarkerPosition.longitude,
                          accuracy: random.nextDouble() * 80000 + 20000,
                        );
                      });
                    });
                  },
                  heroTag: null,
                  child: const Icon(
                    Icons.vertical_align_top,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName:
                'net.tlserver6y.flutter_map_location_marker.example',
            maxZoom: 19,
          ),
          CurrentLocationLayer(
            positionStream: stream,
            moveAnimationDuration: const Duration(seconds: 2),
          ),
        ],
      ),
    );
  }
}
