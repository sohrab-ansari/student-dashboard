// class UserModel {
//   final String? id;
//   final String? name;
//   final String? email;
//   final String? course;
//   final String? studentCode;
//   final String? role;
//   final String? createdAt;

//   UserModel({
//     this.id,
//     this.name,
//     this.email,
//     this.course,
//     this.studentCode,
//     this.role,
//     this.createdAt,
//   });

//   int? get studentId => id != null ? int.tryParse(id!) : null;

//   bool get isAdmin => role == 'admin';
//   bool get isStudent => role != 'admin';

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['id']?.toString(),
//       name: map['name']?.toString(),
//       email: map['email']?.toString(),
//       course: map['course']?.toString(),
//       studentCode: map['student_code']?.toString(),
//       role: map['role']?.toString(),
//       createdAt: map['created_at']?.toString(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       if (id != null) 'id': id,
//       'name': name,
//       'email': email,
//       'course': course,
//       'student_code': studentCode,
//     };
//   }
// }

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? course;
  final String? studentCode;
  final String? role;
  final String? createdAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.course,
    this.studentCode,
    this.role,
    this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  bool get isStudent => role != 'admin';

  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     id: map['id']?.toString(),

  //     name: map['name']?.toString(),

  //     email: map['email']?.toString(),

  //     course: map['course']?.toString(),

  //     studentCode: map['student_code']?.toString(),

  //     role: map['role']?.toString(),

  //     createdAt: map['created_at']?.toString(),
  //   );
  // }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString(),
      name: map['name']?.toString(),
      email: map['email']?.toString(),
      course: map['course']?.toString(),
      studentCode: map['student_code']?.toString(),
      role: map['role']?.toString(),
      createdAt: map['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'course': course,
      'student_code': studentCode,
      'role': role,
      if (createdAt != null) 'created_at': createdAt,
    };
  }
}
