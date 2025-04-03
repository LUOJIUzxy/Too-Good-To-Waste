import 'package:flutter/material.dart';
import 'package:tooGoodToWaste/dto/user_preference_model.dart';

class FoodPreferencePicker extends StatefulWidget {
  final FoodPreference? initialFoodPreference;

  const FoodPreferencePicker({super.key, this.initialFoodPreference});

  @override
  State<FoodPreferencePicker> createState() => _FoodPreferencePickerState();
}

class _FoodPreferencePickerState extends State<FoodPreferencePicker> {
  FoodPreference? _prefState;

  @override
  void initState() {
    super.initState();
    _prefState = widget.initialFoodPreference;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Choose Preference"),
      content: IntrinsicHeight(
        child: Column(
          children: FoodPreference.values
              .map((e) => ListTile(
                    title: Text(e.name),
                    leading: Radio<FoodPreference>(
                      value: e,
                      groupValue: _prefState,
                      onChanged: (FoodPreference? value) {
                        setState(() {
                          _prefState = value;
                        });
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Clear')),
        TextButton(
            onPressed: () => Navigator.pop(context, _prefState),
            child: const Text('OK'))
      ],
    );
  }
}
