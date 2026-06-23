class ComplaintModel {
  final String? id;
  final String? userId;
  final String? message;
  final String? status;
  final DateTime? createdAt;
  final String? userName;

  ComplaintModel({
    this.id,
    this.userId,
    this.message,
    this.status,
    this.createdAt,
    this.userName,
  });

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['id']?.toString(),
      userId: map['user_id']?.toString(),
      message: map['message']?.toString(),
      status: map['status']?.toString() ?? 'Pending',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
      userName: map['students'] != null
          ? (map['students'] as Map<String, dynamic>)['name']?.toString()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'message': message,
      'status': status ?? 'Pending',
    };
  }
}
