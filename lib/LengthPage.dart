import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flutter/services.dart';

List<String> lengths = [
  'mm',
  'cm',
  'm',
  'km',
  'in',
  'ft',
  'yd',
  'mi',
];

Map<String, Map<String, double>> lengthsCoefficients = {
  'mm': {
    'cm': 0.1,
    'm': 0.001,
    'km': 0.000001,
    'in': 0.0393701,
    'ft': 0.00328084,
    'yd': 0.00109361,
    'mi': 6.2137e-7,
  },
  'cm': {
    'mm': 10.0,
    'm': 0.01,
    'km': 1e-5,
    'in': 0.393701,
    'ft': 0.0328084,
    'yd': 0.0109361,
    'mi': 6.2137e-6,
  },
  'm': {
    'mm': 1000.0,
    'cm': 100.0,
    'km': 0.001,
    'in': 39.3701,
    'ft': 3.28084,
    'yd': 1.09361,
    'mi': 6.2137e-4,
  },
  'km': {
    'mm': 1e6,
    'cm': 100000.0,
    'm': 1000.0,
    'in': 39370.1,
    'ft': 3280.84,
    'yd': 1093.61,
    'mi': 0.621371,
  },
  'in': {
    'mm': 25.4,
    'cm': 2.54,
    'm': 0.0254,
    'km': 2.54e-5,
    'ft': 0.0833333,
    'yd': 0.0277778,
    'mi': 1.57828e-5,
  },
  'ft': {
    'mm': 304.8,
    'cm': 30.48,
    'm': 0.3048,
    'km': 3.048e-4,
    'in': 12.0,
    'yd': 0.3333333,
    'mi': 1.89394e-4,
  },
  'yd': {
    'mm': 914.4,
    'cm': 91.44,
    'm': 0.9144,
    'km': 0.0009144,
    'in': 36.0,
    'ft': 3.0,
    'mi': 0.000568182,
  },
  'mi': {
    'mm': 1.60934e6,
    'cm': 160934.0,
    'm': 1609.34,
    'km': 1.60934,
    'in': 63360.0,
    'ft': 5280.0,
    'yd': 1760.0,
  },
};

double convert(String from, String to, double toConvert) {
  if (from == to) return toConvert;
  return (lengthsCoefficients[from]?[to] ?? 1.0) * toConvert;
}

class LengthPage extends StatefulWidget {
  const LengthPage({super.key});

  @override
  State<LengthPage> createState() => _LengthPageState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _LengthPageState extends State<LengthPage> {
  String dropdownValueToConvert = lengths.first;
  String dropdownValueConverted = lengths.first;
  double toConvert = 0.0;

  double get convertedValue => convert(dropdownValueToConvert, dropdownValueConverted, toConvert);

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    lengths.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Convert Lengths'),
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
                      RegExp(r'^\d*[\.,]?\d{0,6}'),
                      ),
                    ],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                          : (convertedValue).toStringAsFixed(6),
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