class Task {
  String id;
  String title;
  String category;
  DateTime deadline;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.deadline,
    this.isCompleted = false,
  });
}
