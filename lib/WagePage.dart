import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flutter/services.dart';

List<String> wages = [
  'KG',
  'g',
  'dag',
  'lbs',
  't',
  'oz',
];

Map<String, Map<String, double>> wagesCoefficients = {
  'KG': {
    'g': 1000.0,
    'dag': 100.0,
    'lbs': 2.20462,
    't': 0.001,
    'oz': 35.274,
  },
  'g': {
    'KG': 0.001,
    'dag': 0.1,
    'lbs': 0.00220462,
    't': 0.000001,
    'oz': 0.035274,
  },
  'dag': {
    'KG': 0.01,
    'g': 10.0,
    'lbs': 0.0220462,
    't': 0.00001,
    'oz': 0.35274,
  },
  'lbs': {
    'KG': 0.453592,
    'g': 453.592,
    'dag': 45.3592,
    't': 0.000453592,
    'oz': 16.0,
  },
  't': {
    'KG': 1000.0,
    'g': 1000000.0,
    'dag': 100000.0,
    'lbs': 2204.62,
    'oz': 35274.0,
  },
  'oz': {
    'KG': 0.0283495,
    'g': 28.3495,
    'dag': 2.83495,
    'lbs': 0.0625,
    't': 2.83495e-5,
  },
};

double convert(String from, String to, double toConvert) {
  if (from == to) return toConvert;
  return (wagesCoefficients[from]?[to] ?? 1.0) * toConvert;
}


class WagePage extends StatefulWidget {
  const WagePage({super.key});

  @override
  State<WagePage> createState() => _WagePageState();
}
typedef MenuEntry = DropdownMenuEntry<String>;

class _WagePageState extends State<WagePage> {
  String dropdownValueToConvert = wages.first;
  String dropdownValueConverted = wages.first;
  double toConvert = 0.0;

  double get convertedValue => convert(dropdownValueToConvert, dropdownValueConverted, toConvert);

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    wages.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Convert Wages'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownMenu<String>(
                  initialSelection: dropdownValueToConvert,
                  onSelected: (String? value) {
                    setState(() {
                      dropdownValueToConvert = value!;
                    });
                  },
                  dropdownMenuEntries: menuEntries,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Amount to convert',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*[\.,]?\d{0,4}'),
                      ),
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      value = value.replaceAll(',', '.');
                      setState(() {
                        toConvert = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownMenu<String>(
                  initialSelection: dropdownValueConverted,
                  onSelected: (String? value) {
                    setState(() {
                      dropdownValueConverted = value!;
                    });
                  },
                  dropdownMenuEntries: menuEntries,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Converted Amount',
                    ),
                    controller: TextEditingController(
                      text: (toConvert == 0 && dropdownValueToConvert == dropdownValueConverted)
                          ? ''
                          : (convertedValue).toStringAsFixed(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}