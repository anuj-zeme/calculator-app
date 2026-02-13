import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:calculator_app/routes/routes_name.dart';
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
          actions: [
            IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Get.toNamed(RoutesName.historyScreen);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: TextField(
                controller: controller.textController,
                readOnly: true,
                showCursor: true,
                enableInteractiveSelection: true,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                contextMenuBuilder: (context, editableTextState) {
                  final List<ContextMenuButtonItem> buttonItems =
                      editableTextState.contextMenuButtonItems;

                  // Add custom paste button
                  buttonItems.insert(
                    buttonItems.length,
                    ContextMenuButtonItem(
                      label: 'Paste',
                      onPressed: () async {
                        ContextMenuController.removeAny();
                        final data = await Clipboard.getData(
                          Clipboard.kTextPlain,
                        );
                        if (data != null && data.text != null) {
                          controller.pasteText(data.text!);
                        }
                      },
                    ),
                  );

                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: editableTextState.contextMenuAnchors,
                    buttonItems: buttonItems,
                  );
                },
                onTap: () {
                  // Allow cursor positioning on tap
                  controller
                      .textController
                      .selection = TextSelection.fromPosition(
                    TextPosition(
                      offset: controller.textController.selection.baseOffset,
                    ),
                  );
                },
                onSubmitted: (value) => controller.calculate(),
              ),
            ),
            const Expanded(child: Divider(thickness: 1, color: Colors.grey)),
            Column(
              children: [
                Row(
                  children: [
                    _buildButton('(', Colors.grey, controller),
                    _buildButton(')', Colors.grey, controller),
                    _buildButton('C', Colors.orange, controller),
                    _buildButton('AC', Colors.orange, controller),
                  ],
                ),
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
                    _buildButton('00', Colors.grey, controller),
                    _buildButton('.', Colors.grey, controller),
                    _buildButton('+', Colors.orange, controller),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: GetBuilder<HomeScreenController>(
                        builder: (controller) {
                          return ScaleTransition(
                            scale: controller.scaleAnim,
                            child: AnimatedBuilder(
                              animation: controller.colorAnim,
                              builder: (context, child) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        controller.colorAnim.value!,
                                  ),
                                  onPressed: controller.onCalculatePressed,
                                  child: const Text(
                                    'Calculate',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
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
