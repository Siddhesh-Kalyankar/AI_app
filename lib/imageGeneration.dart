import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ImageGeneration extends StatefulWidget {
  const ImageGeneration({super.key});

  @override
  _ImageGenerationState createState() => _ImageGenerationState();
}

class _ImageGenerationState extends State<ImageGeneration> {
  List<Map<String, String>> searchHistory = [];
  bool isLoading = false;
  final TextEditingController _controller = TextEditingController();
  String apiKey = "56c4ab2608msh4a5a119def57368p158eb4jsn3af0e4420223";

  Future<void> generateImage() async {
    if (_controller.text.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    String userQuery = _controller.text;
    final url = Uri.parse("https://ai-image-generator14.p.rapidapi.com/");
    final headers = {
      "Content-Type": "application/json",
      "x-rapidapi-host": "ai-image-generator14.p.rapidapi.com",
      "x-rapidapi-key": apiKey,
    };
    final body = jsonEncode({
      "jsonBody": {
        "function_name": "image_generator",
        "type": "image_generation",
        "query": userQuery,
        "output_type": "png",
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseData = jsonDecode(response.body);
      print("API Response: $responseData");

      if (responseData["message"] != null &&
          responseData["message"]["status"] == "success" &&
          responseData["message"].containsKey("output_png")) {
        String imageUrl = responseData["message"]["output_png"];

        setState(() {
          searchHistory.insert(0, {"query": userQuery, "imageUrl": imageUrl});
        });
      } else {
        print("Error: Unexpected API response format");
      }
    } catch (e) {
      print("Error fetching image: $e");
    }

    setState(() {
      isLoading = false;
      _controller.clear();
    });
  }

  void clearHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Image Generator"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: clearHistory,
            tooltip: "Clear History",
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Enter image description",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generateImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Button color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Generate Image",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Expanded(
                child:
                    searchHistory.isEmpty
                        ? const Center(
                          child: Text(
                            "No images generated yet.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                        : ListView.builder(
                          itemCount: searchHistory.length,
                          itemBuilder: (context, index) {
                            final item = searchHistory[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Generated for: \"${item["query"]}\"",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(item["imageUrl"]!),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
