class TaskModel {
  final int? id;
  final int studentId;
  final String title;
  final String? description;
  final String status;
  final DateTime? deadline;

  TaskModel({
    this.id,
    required this.studentId,
    required this.title,
    this.description,
    required this.status,
    this.deadline,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      studentId: map['student_id'],
      title: map['title'] ?? '',
      description: map['description'],
      status: map['status'] ?? 'Pending',
      deadline: map['due_date'] != null
          ? DateTime.parse(map['due_date'])
          : null,
          
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_id': studentId,
      'title': title,
      'description': description,
      'status': status,
      if (deadline != null)
        'due_date': deadline!.toIso8601String(),
    };
  }
}