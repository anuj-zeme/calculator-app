import 'package:calculator_app/screens/home_screen/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the controller if it's already there, or put it.
    // Since we navigate from HomeScreen, it should be there.
    final HomeScreenController controller = Get.find<HomeScreenController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              controller.clearHistory();
              Get.snackbar(
                "Cleared",
                "History cleared successfully",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.history.isEmpty
            ? const Center(
                child: Text(
                  "No History",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: controller.history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      controller.history[index],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onTap: () {
                      // Optionally, populate the calculator with this result
                      // For now, just copy it or do nothing
                    },
                  );
                },
              ),
      ),
    );
  }
}
