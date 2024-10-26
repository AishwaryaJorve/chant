import 'package:chants/chant.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  // final void Function() chant;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/chant7.png',
            color: const Color.fromARGB(255, 205, 131, 181),
            width: 300,
          ),
          const SizedBox(
            height: 100,
          ),
          const Text(
            "Spiritual Growth",
            style: TextStyle(
                color: Color.fromARGB(255, 221, 205, 205), fontSize: 24),
          ),
          const SizedBox(
            height: 30,
          ),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Chant()),
              );
            },
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.arrow_right_alt_outlined),
            label: const Text("Get Started"),
          )
        ],
      ),
    );
  }
}
