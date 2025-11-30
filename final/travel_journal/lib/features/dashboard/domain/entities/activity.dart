class Activity {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final int tripId;

  Activity({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.tripId,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['is_completed'] as bool,
      tripId: json['trip_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'trip_id': tripId,
    };
  }

  Activity copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? tripId,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      tripId: tripId ?? this.tripId,
    );
  }

  @override
  String toString() {
    return 'Activity{id: $id, title: $title, description: $description, isCompleted: $isCompleted, tripId: $tripId}';
  }
}
