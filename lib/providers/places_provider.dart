import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:place_tracker/models/place.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  return sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            location: PlaceLocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
            image: File(row['image'] as String),
            title: row['title'] as String,
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$filename');

    final db = await _getDatabase();
    db.insert(
      'user_places',
      {
        'id': place.id,
        'title': place.title,
        'image': copiedImage.path,
        'lat': place.location.latitude,
        'lng': place.location.longitude,
        'address': place.location.address,
      },
    );
    state = [
      ...state,
      Place(
        location: place.location,
        image: copiedImage,
        title: place.title,
      ),
    ];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
    (ref) => PlacesNotifier());
