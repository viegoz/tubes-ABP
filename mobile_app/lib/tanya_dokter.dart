import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'question_provider.dart';

class TanyaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tanya Dokter'),
      ),
      body: Consumer<QuestionProvider>(
        builder: (context, questionProvider, child) {
          return ListView.builder(
            itemCount: questionProvider.questions.length,
            itemBuilder: (context, index) {
              final question = questionProvider.questions[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(question.question),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
