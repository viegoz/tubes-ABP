import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question_model.dart';

class ApiService {
  static const String _baseUrl = 'http://192.168.8.171:3001';

  Future<void> addPatient(Map<String, dynamic> patientData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/pasien'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patientData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add patient: ${response.body}');
    }
  }

  Future<void> addUser(String username, String password, String status,
      String name, String email) async {
    final url = Uri.parse('$_baseUrl/addUser');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'status': status,
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      print('User added successfully');
    } else {
      print('Failed to add user: ${response.body}');
    }
  }

  Future<Question> addQuestion(String username, String question) async {
    final url = Uri.parse('$_baseUrl/questions');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'question': question,
      }),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Question(
        id: data['id'],
        username: data['username'],
        question: data['question'],
        comments: [], // Awalnya tidak ada komentar
      );
    } else {
      throw Exception('Failed to add question: ${response.body}');
    }
  }

  Future<void> addComment(int questionId, String comment) async {
    final url = Uri.parse('$_baseUrl/questions/$questionId/comments');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'comment': comment,
      }),
    );

    if (response.statusCode == 201) {
      print('Comment added successfully');
    } else {
      print('Failed to add comment: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final url = Uri.parse('$_baseUrl/questions');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load questions');
    }
  }

  Future<List<Map<String, dynamic>>> fetchComments(int questionId) async {
    final url = Uri.parse('$_baseUrl/questions/$questionId/comments');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> deleteQuestion(int questionId) async {
    final url = Uri.parse('$_baseUrl/questions/$questionId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete question: ${response.body}');
    }
  }
}
