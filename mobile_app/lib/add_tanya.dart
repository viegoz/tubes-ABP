import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'question_provider.dart';
import 'question_model.dart';
import 'api_service.dart';

class AddTanyaPage extends StatefulWidget {
  @override
  _AddTanyaPageState createState() => _AddTanyaPageState();
}

class _AddTanyaPageState extends State<AddTanyaPage> {
  final _questionController = TextEditingController();
  final ApiService _apiService = ApiService(); // Inisialisasi ApiService
  bool _isLoading = false; // Untuk menampilkan indikator loading

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pertanyaan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Pertanyaan'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Indikator loading
                : ElevatedButton(
                    onPressed: () async {
                      final questionText = _questionController.text;
                      final username =
                          'User Login'; // Dapatkan username dari sistem login
                      if (questionText.isNotEmpty) {
                        setState(() {
                          _isLoading = true; // Tampilkan loading saat menunggu
                        });
                        try {
                          // Tambahkan pertanyaan ke database dan dapatkan ID baru
                          await _apiService.addQuestion(username, questionText);
                          // Dapatkan kembali daftar pertanyaan untuk memperbarui UI
                          await Provider.of<QuestionProvider>(context,
                                  listen: false)
                              .fetchQuestions();
                          Navigator.pop(context);
                        } catch (e) {
                          // Tampilkan pesan kesalahan jika gagal
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to add question: $e')),
                          );
                        } finally {
                          setState(() {
                            _isLoading = false; // Sembunyikan indikator loading
                          });
                        }
                      } else {
                        // Tampilkan pesan kesalahan jika pertanyaan kosong
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Pertanyaan tidak boleh kosong')),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }
}
