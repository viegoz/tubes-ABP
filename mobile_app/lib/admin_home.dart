import 'package:flutter/material.dart';
import 'package:mobile_app/login_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'question_provider.dart';
import 'api_service.dart';

class AdminHomePage extends StatelessWidget {
  final ApiService _apiService = ApiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Future<void> _addNotification(BuildContext context) async {
    final title = _titleController.text;
    final message = _messageController.text;

    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and message cannot be empty')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.8.171:3001/notifications'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'message': message}),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification added successfully')),
      );
      _titleController.clear();
      _messageController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add notification')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => LogInPage(),
                            ),
                          );
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Notification',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Notification Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Notification Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _addNotification(context),
                    child: Text('Add Notification'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<QuestionProvider>(
              builder: (context, questionProvider, child) {
                return ListView.builder(
                  itemCount: questionProvider.questions.length,
                  itemBuilder: (context, index) {
                    final question = questionProvider.questions[index];
                    final commentController = TextEditingController();

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  question.username,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    try {
                                      await Provider.of<QuestionProvider>(
                                              context,
                                              listen: false)
                                          .deleteQuestion(question.id, index);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Question deleted successfully')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to delete question: $e')),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(question.question),
                            SizedBox(height: 8),
                            TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                labelText: 'Add a comment',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final comment = commentController.text;
                                if (comment.isNotEmpty) {
                                  await Provider.of<QuestionProvider>(context,
                                          listen: false)
                                      .addComment(question.id, index, comment);
                                  commentController.clear();
                                }
                              },
                              child: Text('Submit'),
                            ),
                            SizedBox(height: 8),
                            Text('Comments:'),
                            ...question.comments
                                .map((comment) => Text('- $comment'))
                                .toList(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
