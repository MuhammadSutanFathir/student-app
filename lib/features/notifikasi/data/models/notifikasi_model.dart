import 'package:student_app/features/notifikasi/domain/entities/notifikasi_entity.dart';

class NotifikasiModel {
  final String title;
  final String body;

  NotifikasiModel({
    required this.title,
    required this.body,
  });

  factory NotifikasiModel.fromFirebase(Map<String, dynamic> data) {
    return NotifikasiModel(
      title: data['title'] ?? '',
      body: data['body'] ?? '',
    );
  }

  NotifikasiEntity toEntity({required bool isActive}) {
    return NotifikasiEntity(
      title: title,
      body: body,
      isActive: isActive,
    );
  }
}
