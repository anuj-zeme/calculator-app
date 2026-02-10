import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeScreenController controller = Get.put(HomeScreenController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Calculator App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: TextField(
                controller: controller.textController,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.+\-*/]')),
                ],
                onSubmitted: (value) => controller.calculate(),
              ),
            ),
            const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
            Column(
              children: [
                Row(
                  children: [
                    _buildButton('7', Colors.grey, controller),
                    _buildButton('8', Colors.grey, controller),
                    _buildButton('9', Colors.grey, controller),
                    _buildButton('/', Colors.orange, controller),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4', Colors.grey, controller),
                    _buildButton('5', Colors.grey, controller),
                    _buildButton('6', Colors.grey, controller),
                    _buildButton('*', Colors.orange, controller),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1', Colors.grey, controller),
                    _buildButton('2', Colors.grey, controller),
                    _buildButton('3', Colors.grey, controller),
                    _buildButton('-', Colors.orange, controller),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0', Colors.grey, controller),
                    _buildButton('.', Colors.grey, controller),
                    _buildButton('C', Colors.grey, controller),
                    _buildButton('+', Colors.orange, controller),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('Calculate', Colors.green, controller),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    String buttonText,
    Color buttonColor,
    HomeScreenController controller,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(9),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(24),
          ),
          onPressed: () => controller.onButtonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
