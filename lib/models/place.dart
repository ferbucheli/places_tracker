import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Place {
  final String title;
  final String id;
  final File image;
  final PlaceLocation location;

  Place({
    required this.location,
    required this.image,
    required this.title,
    String? id,
  }) : id = id ?? uuid.v4();
}
