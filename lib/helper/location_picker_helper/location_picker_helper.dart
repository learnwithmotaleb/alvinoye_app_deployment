import 'package:flutter/material.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:delivery_app/features/driver/commuter_registration/models/record_location.dart';

Future<void> openLocationPicker({
  required BuildContext context,
  required bool isFromField,
  required ValueNotifier<RecordLocation> fromLocation,
  required ValueNotifier<RecordLocation> toLocation,
  required TextEditingController fromController,
  required TextEditingController toController,
}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MapLocationPicker(
        config: MapLocationPickerConfig(
          apiKey: "AIzaSyDZqCZMjhwfqoGdhvvZJ6_1zc3-UbZUvIo",
          initialPosition: const LatLng(-22.3285, 24.6849),
          onNext: (result) {
            if (result != null) {
              final address =
                  result.formattedAddress ?? "Address not available";
              final location = RecordLocation(
                LatLng(
                  result.geometry?.location.lat ?? 0,
                  result.geometry?.location.lng ?? 0,
                ),
                address,
              );
              if (isFromField) {
                fromLocation.value = location;
                fromController.text = address;
              } else {
                toLocation.value = location;
                toController.text = address;
              }
            }
            if (context.mounted) {
              Navigator.pop(context, result);
            }
          },
        ),
        searchConfig: const SearchConfig(
          apiKey: "AIzaSyDZqCZMjhwfqoGdhvvZJ6_1zc3-UbZUvIo",
          searchHintText: "Search for a location",
        ),
      ),
    ),
  );
}
