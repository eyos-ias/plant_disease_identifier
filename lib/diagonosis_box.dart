import 'package:flutter/material.dart';

class DiagnosisBox extends StatelessWidget {
  final Map<String, dynamic> data;

  DiagnosisBox({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$key:'),
              if (value is Map<String, dynamic>) // Check if the value is a map
                DiagnosisBox(data: value) // Recursively create a KeyValueWidget
              else
                Text('  $value'), // Display the value as text
            ],
          ),
        );
      }).toList(),
    );
  }
}
