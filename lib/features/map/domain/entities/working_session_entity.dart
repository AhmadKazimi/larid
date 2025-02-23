class WorkingSessionEntity {
  final int id;
  final String userId;
  final String workspace;
  final String dayName;
  final String date;
  final String startTime;
  final int startTimestamp;
  final String? endTime;

  const WorkingSessionEntity({
    required this.id,
    required this.userId,
    required this.workspace,
    required this.dayName,
    required this.date,
    required this.startTime,
    required this.startTimestamp,
    this.endTime,
  });

  factory WorkingSessionEntity.fromMap(Map<String, dynamic> map) {
    return WorkingSessionEntity(
      id: map['id'] as int,
      userId: map['user_id'] as String,
      workspace: map['workspace'] as String,
      dayName: map['day_name'] as String,
      date: map['date'] as String,
      startTime: map['start_time'] as String,
      startTimestamp: map['start_timestamp'] as int,
      endTime: map['end_time'] as String?,
    );
  }
}
