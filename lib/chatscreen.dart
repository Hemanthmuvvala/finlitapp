import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {
      "text": "Hi! I'm your AI financial assistant. How can I help you today?",
      "isAI": true
    }
  ];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // Gemini API configuration
  final String apiKey = "AIzaSyBxEbqvhDsHbjmvysyo1K8AzHA409vuCoY"; // Replace with your actual API key
  String get apiUrl => "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey";
  
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // History of conversation for context
  List<Map<String, dynamic>> chatHistory = [];

  // Categories with their content
  final Map<String, Map<String, List<String>>> categories = {
    "Learn": {
      "Stocks": [
        "Introduction to Stock Market",
        "How to Read Stock Charts",
        "Understanding P/E Ratios",
        "Dividend Stocks Explained",
        "Stock Market Risk Management"
      ],
      "Banking": [
        "Banking Basics",
        "Savings vs. Checking Accounts",
        "Understanding Interest Rates",
        "Mobile Banking Safety",
        "Credit Score Fundamentals"
      ],
      "Mutual Funds": [
        "What are Mutual Funds?",
        "Active vs Passive Funds",
        "Expense Ratios Explained",
        "Fund Performance Metrics",
        "Choosing the Right Fund"
      ],
      "Insurance": [
        "Insurance Fundamentals",
        "Life Insurance Options",
        "Health Insurance Explained",
        "Property Insurance Basics",
        "Understanding Premiums and Deductibles"
      ],
    },
    "Invest": {
      "Gold": [
        "Physical Gold vs Gold ETFs",
        "Gold as an Investment",
        "Gold Market Trends",
        "Sovereign Gold Bonds"
      ],
      "Mutual Funds": [
        "SIP Investment Strategy",
        "Fund Selection Criteria",
        "Tax Benefits of ELSS Funds",
        "Lumpsum vs Regular Investing"
      ],
      "SIP": [
        "Systematic Investment Plans Explained",
        "Choosing SIP Duration",
        "SIP Calculator Tutorial",
        "SIP vs Lumpsum Comparison"
      ],
      "Stocks": [
        "Fundamental Analysis",
        "Technical Analysis Basics",
        "Creating a Balanced Portfolio",
        "Long-term Stock Investment"
      ],
      "Insurance": [
        "Insurance as Investment",
        "ULIP Benefits and Drawbacks",
        "Term Insurance ROI",
        "Endowment Plans Explained"
      ],
    }
  };

  Future<void> _sendMessageToGemini(String message) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Update chat history for context
      chatHistory.add({"role": "user", "parts": [{"text": message}]});

      // Prepare the request body according to Gemini API format
      final requestBody = {
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text": message
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1000,
        }
      };

      // For continuous conversation, you can add history
      if (chatHistory.length > 1) {
        requestBody["contents"] = chatHistory.map((msg) => {
          "role": msg["role"],
          "parts": msg["parts"]
        }).toList();
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse the response according to Gemini API response format
        final Map<String, dynamic> data = jsonDecode(response.body);
        String aiResponse = "";
        
        if (data.containsKey('candidates') && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0].containsKey('content') &&
            data['candidates'][0]['content'].containsKey('parts') &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          
          aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
          
          // Update chat history with AI response
          chatHistory.add({"role": "model", "parts": [{"text": aiResponse}]});
        } else {
          aiResponse = "I couldn't generate a response. Please try again.";
        }

        setState(() {
          messages.add({
            "text": aiResponse,
            "isAI": true
          });
          _isLoading = false;
        });
      } else {
        // Handle error
        String errorMessage = "Sorry, I encountered an error. Please try again later.";
        try {
          final errorData = jsonDecode(response.body);
          if (errorData.containsKey('error') && 
              errorData['error'].containsKey('message')) {
            errorMessage = "Error: ${errorData['error']['message']}";
          }
        } catch (e) {
          // Use default error message if parsing fails
        }
        
        setState(() {
          messages.add({
            "text": errorMessage,
            "isAI": true
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        messages.add({
          "text": "Network error. Please check your connection and try again.",
          "isAI": true
        });
        _isLoading = false;
      });
    }
    
    _scrollToBottom();
  }

  void _sendMessage() {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      messages.add({"text": userInput, "isAI": false});
      _controller.clear();
    });

    _sendMessageToGemini(userInput);
  }

  void _showCategoryContent(String category, String topic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$topic Videos"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories[category]![topic]!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(categories[category]![topic]![index]),
                  onTap: () {
                    Navigator.pop(context);
                    _showVideoPlayer(categories[category]![topic]![index]);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close")
            )
          ],
        );
      },
    );
  }
  
  void _showVideoPlayer(String videoTitle) {
    // In a real app, you'd navigate to a video player
    // For this example, we'll just show a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Playing Video"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 180,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.play_arrow, size: 50),
                ),
              ),
              const SizedBox(height: 15),
              Text(videoTitle),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close")
            )
          ],
        );
      },
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("About FinLit AI"),
          content: const Text(
              "FinLit AI helps you understand finance with AI-driven insights."),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 209, 205, 205),
        title: const Text("FinLit AI"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _showCategoryContent("Learn", value);
            },
            itemBuilder: (BuildContext context) => categories["Learn"]!.keys.map((String key) {
              return PopupMenuItem<String>(
                value: key,
                child: Text(key),
              );
            }).toList(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [Icon(Icons.school), Text(" Learn")]),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              _showCategoryContent("Invest", value);
            },
            itemBuilder: (BuildContext context) => categories["Invest"]!.keys.map((String key) {
              return PopupMenuItem<String>(
                value: key,
                child: Text(key),
              );
            }).toList(),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [Icon(Icons.trending_up), Text(" Invest")]),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAboutDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isAI = messages[index]["isAI"];
                return Align(
                  alignment:
                      isAI ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isAI ? Colors.grey[300] : Colors.blue[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index]["text"],
                      style:
                          TextStyle(color: isAI ? Colors.black : Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text("Chankaya AI is typing..."),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}