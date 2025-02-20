import 'package:flutter/material.dart';
import 'chatbot.dart';
import 'imageGeneration.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning, what task can I do for you?";
    } else if (hour < 18) {
      return "Good Afternoon, how can I assist you?";
    } else {
      return "Good Evening, let's get things done!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "AI Assistant",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingCard(),
            const SizedBox(height: 24),
            const Text(
              "Here are a few features",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FeatureButton(
              title: "Chatbot",
              description:
                  "A smarter way to stay organized and informed with AI.",
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Chatbot()),
                );
              },
            ),
            const SizedBox(height: 12),
            FeatureButton(
              title: "AI Image Generator",
              description: "Generate stunning images with AI creativity.",
              color: Colors.blue.shade300,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImageGeneration(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            FeatureButton(
              title: "Smart Voice Assistant",
              description: "Talk to your AI-powered voice assistant.",
              color: Colors.lightBlueAccent,
              onPressed: () {
                print("Smart Voice Assistant Pressed");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.person, size: 50, color: Colors.black),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              getGreeting(),
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String title;
  final String description;
  final Color color;
  final VoidCallback onPressed;

  const FeatureButton({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Explore"),
            ),
          ),
        ],
      ),
    );
  }
}
