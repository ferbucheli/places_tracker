import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:place_tracker/providers/places_provider.dart';
import 'package:place_tracker/screens/add_place_screen.dart';
import 'package:place_tracker/widgets/places_list.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PlacesListScreenState();
  }
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placesFuture;
  @override
  void initState() {
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final places = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Great Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AddPlaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PlacesList(places: places),
        ),
      ),
    );
  }
}
