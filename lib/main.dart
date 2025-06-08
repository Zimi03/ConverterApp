import 'package:flutter/material.dart';
import 'CurrencyPage.dart';

void main() {
  runApp(const Converter());
}


class Converter extends StatelessWidget {
  const Converter({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConverterHome(),
    );
  }
}

class ConverterHome extends StatelessWidget {
  const ConverterHome({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text('Unit Converter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.money, 
                    size: 50,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CurrencyPage(),
                        ),
                      );
                    }, 
                    child: Text(
                      'Waluty',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.scale,
                    size: 50,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Wagi',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.straighten,
                    size: 50,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Długości',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
