class Question {
  final int id;
  final String username;
  final String question;
  List<String> comments;

  Question({
    required this.id,
    required this.username,
    required this.question,
    required this.comments,
  });

  // Method untuk membuat salinan baru dengan perubahan
  Question copyWith({List<String>? comments}) {
    return Question(
      id: id,
      username: username,
      question: question,
      comments: comments ?? this.comments,
    );
  }

  // Method untuk menambahkan komentar
  void addComment(String comment) {
    comments = List.from(comments)..add(comment);
  }

  // Method untuk membuat Question dari JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      username: json['username'],
      question: json['question'],
      comments: List<String>.from(json['comments'] ?? []),
    );
  }
}
