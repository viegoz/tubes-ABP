import 'package:flutter/material.dart';
import 'question_model.dart';
import 'api_service.dart';

class QuestionProvider with ChangeNotifier {
  List<Question> _questions = [];

  List<Question> get questions => _questions;

  final ApiService _apiService = ApiService();

  QuestionProvider() {
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      List<Map<String, dynamic>> questionsJson =
          await _apiService.fetchQuestions();
      _questions =
          questionsJson.map((json) => Question.fromJson(json)).toList();
      for (var question in _questions) {
        List<Map<String, dynamic>> commentsJson =
            await _apiService.fetchComments(question.id);
        question.comments = commentsJson
            .map((commentJson) => commentJson['comment'] as String)
            .toList();
      }
      notifyListeners();
    } catch (e) {
      print('Failed to load questions: $e');
    }
  }

  void addQuestion(Question question) {
    _questions.add(question);
    notifyListeners();
  }

  Future<void> addComment(
      int questionId, int questionIndex, String comment) async {
    try {
      await _apiService.addComment(questionId, comment);
      _questions[questionIndex].addComment(comment);
      notifyListeners();
    } catch (e) {
      print('Failed to add comment: $e');
    }
  }

  Future<void> deleteQuestion(int questionId, int questionIndex) async {
    try {
      await _apiService.deleteQuestion(questionId);
      _questions.removeAt(questionIndex);
      notifyListeners();
    } catch (e) {
      print('Failed to delete question: $e');
    }
  }
}
