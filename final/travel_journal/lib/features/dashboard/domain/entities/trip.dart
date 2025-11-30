class Trip {
  final int? id;
  final String name;
  final String destination;
  final String startDate;
  final String endDate;
  final String imageUrl;

  Trip({
    this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as int?,
      name: json['name'] as String,
      destination: json['destination'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'destination': destination,
      'start_date': startDate,
      'end_date': endDate,
      'image_url': imageUrl,
    };
  }

  Trip copyWith({
    int? id,
    String? name,
    String? destination,
    String? startDate,
    String? endDate,
    String? imageUrl,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'Trip{id: $id, name: $name, destination: $destination, startDate: $startDate, endDate: $endDate, imageUrl: $imageUrl}';
  }
}
