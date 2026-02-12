import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> scaleAnim;
  late Animation<Color?> colorAnim;

  final TextEditingController textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode(canRequestFocus: false);

  final storage = GetStorage();
  RxList<String> history = <String>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Load history
    if (storage.hasData('history')) {
      history.assignAll(List<String>.from(storage.read('history')));
    }

    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 400),
    );

    scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeOut));

    colorAnim = ColorTween(
      begin: Colors.green,
      end: Colors.green.shade700,
    ).animate(animController);
  }

  @override
  void onClose() {
    animController.dispose();
    textController.dispose();
    textFocusNode.dispose();
    super.onClose();
  }

  void onCalculatePressed() async {
    await animController.forward();
    await animController.reverse();
    calculate();
  }

  void onButtonPressed(String value) {
    if (value == 'C') {
      textController.clear();
    } else if (value == 'Calculate' || value == '=') {
      calculate();
    } else {
      // Insert value at current cursor position
      final currentText = textController.text;
      final cursorPosition = textController.selection.baseOffset;

      // If cursor position is valid, insert at that position
      if (cursorPosition >= 0) {
        final newText =
            currentText.substring(0, cursorPosition) +
            value +
            currentText.substring(cursorPosition);
        textController.text = newText;

        // Move cursor to after the inserted character
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: cursorPosition + value.length),
        );
      } else {
        // Fallback: append to end if cursor position is invalid
        textController.text = currentText + value;
      }
    }
  }

  void pasteText(String text) {
    // Insert pasted text at current cursor position
    final currentText = textController.text;
    final cursorPosition = textController.selection.baseOffset;

    if (cursorPosition >= 0) {
      final newText =
          currentText.substring(0, cursorPosition) +
          text +
          currentText.substring(cursorPosition);
      textController.text = newText;

      // Move cursor to after the pasted text
      textController.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition + text.length),
      );
    } else {
      // Fallback: append to end if cursor position is invalid
      textController.text = currentText + text;
    }
  }

  void calculate() {
    String currentText = textController.text;
    if (currentText.isEmpty) return;

    if (['+', '-', '*', '/'].contains(currentText[currentText.length - 1])) {
      return;
    }

    try {
      double result = _evaluateExpression(currentText);

      String resultStr;
      if (result % 1 == 0) {
        resultStr = result.toInt().toString();
      } else {
        resultStr = result.toString();
      }

      textController.text = resultStr;

      // Add to history
      _addToHistory("$currentText = $resultStr");
    } catch (e) {
      textController.text = "Error";
    }
  }

  void _addToHistory(String entry) {
    history.insert(0, entry);
    if (history.length > 20) {
      history.removeLast();
    }
    storage.write('history', history.toList());
  }

  void clearHistory() {
    history.clear();
    storage.remove('history');
  }

  double _evaluateExpression(String expr) {
    if (expr.isEmpty) return 0;

    // 1. Tokenize: Split numbers and operators
    List<String> tokens = [];
    String currentNumber = '';

    for (int i = 0; i < expr.length; i++) {
      String char = expr[i];
      if (['+', '-', '*', '/'].contains(char)) {
        if (currentNumber.isNotEmpty) {
          tokens.add(currentNumber);
          currentNumber = '';
        }
        tokens.add(char);
      } else {
        currentNumber += char;
      }
    }
    if (currentNumber.isNotEmpty) {
      tokens.add(currentNumber);
    }

    // If no tokens found, return 0
    if (tokens.isEmpty) return 0;

    // 2. Handle * and / (Precedence)
    // Create new list for next pass
    List<String> pass1 = [];

    for (int i = 0; i < tokens.length; i++) {
      String token = tokens[i];
      if (token == '*' || token == '/') {
        if (pass1.isEmpty) {
          pass1.add('0');
        }

        double left = double.tryParse(pass1.removeLast()) ?? 0.0;
        // Safety: check if next token exists
        if (i + 1 >= tokens.length) break;

        double right = double.tryParse(tokens[++i]) ?? 0.0;

        if (token == '*') {
          pass1.add((left * right).toString());
        } else {
          if (right == 0) throw Exception("Div0");
          pass1.add((left / right).toString());
        }
      } else {
        pass1.add(token);
      }
    }

    // 3. Handle + and -
    if (pass1.isEmpty) return 0;

    double result = double.tryParse(pass1[0]) ?? 0.0;
    for (int i = 1; i < pass1.length; i += 2) {
      if (i + 1 >= pass1.length) break;

      String op = pass1[i];
      double nextVal = double.tryParse(pass1[i + 1]) ?? 0.0;

      if (op == '+') result += nextVal;
      if (op == '-') result -= nextVal;
    }

    return result;
  }
}
