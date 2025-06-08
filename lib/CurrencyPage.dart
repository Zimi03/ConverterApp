import 'package:flutter/material.dart';
import 'dart:collection';

List<String> currencies = [
  'PLN',
  'USD',
  'EUR',
  'GBP',
];

Map<String, Map<String, double>> currenciesCoefficients = {
  'PLN': {
    'USD': 0.25,
    'EUR': 0.22,
    'GBP': 0.19,
  },
  'USD': {
    'PLN': 4.0,
    'EUR': 0.88,
    'GBP': 0.76,
  },
  'EUR': {
    'PLN': 4.5,
    'USD': 1.14,
    'GBP': 0.86,
  },
  'GBP': {
    'PLN': 5.2,
    'USD': 1.32,
    'EUR': 1.16,
  },
};

double convert(String from, String to, double toConvert) {
  if (from == to) return toConvert;
  return (currenciesCoefficients[from]?[to] ?? 1.0) * toConvert;
}

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

typedef MenuEntry = DropdownMenuEntry<String>;

class _CurrencyPageState extends State<CurrencyPage> {
  String dropdownValueToConvert = currencies.first;
  String dropdownValueConverted = currencies.first;
  double toConvert = 0.0;

  double get convertedValue => convert(dropdownValueToConvert, dropdownValueConverted, toConvert);

  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    currencies.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Convert Currencies'),
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
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
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
                          : (convertedValue).toStringAsFixed(2),
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
