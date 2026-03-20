class BodyMeasurements {
  final double chest; // in cm
  final double arms; // in cm
  final double waist; // in cm
  final double thighs; // in cm
  final DateTime date;

  const BodyMeasurements({
    required this.chest,
    required this.arms,
    required this.waist,
    required this.thighs,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'chest': chest,
      'arms': arms,
      'waist': waist,
      'thighs': thighs,
      'date': date.toIso8601String(),
    };
  }

  factory BodyMeasurements.fromMap(Map<String, dynamic> map) {
    return BodyMeasurements(
      chest: (map['chest'] ?? 0).toDouble(),
      arms: (map['arms'] ?? 0).toDouble(),
      waist: (map['waist'] ?? 0).toDouble(),
      thighs: (map['thighs'] ?? 0).toDouble(),
      date: DateTime.parse(map['date']),
    );
  }
}

class WeightEntry {
  final String? id;
  final String userId;
  final double weight; // in kg
  final DateTime date;
  final String? notes;

  const WeightEntry({
    this.id,
    required this.userId,
    required this.weight,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'],
      userId: map['userId'],
      weight: (map['weight'] ?? 0).toDouble(),
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }

  WeightEntry copyWith({
    String? id,
    String? userId,
    double? weight,
    DateTime? date,
    String? notes,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}

class ProgressPhoto {
  final String? id;
  final String userId;
  final String photoUrl;
  final DateTime date;
  final String? notes;

  const ProgressPhoto({
    this.id,
    required this.userId,
    required this.photoUrl,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'photoUrl': photoUrl,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory ProgressPhoto.fromMap(Map<String, dynamic> map) {
    return ProgressPhoto(
      id: map['id'],
      userId: map['userId'],
      photoUrl: map['photoUrl'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
    );
  }
}

class ProgressEntry {
  final String? id;
  final String userId;
  final DateTime date;
  final double? weight;
  final BodyMeasurements? measurements;
  final String? photoUrl;
  final String? notes;

  const ProgressEntry({
    this.id,
    required this.userId,
    required this.date,
    this.weight,
    this.measurements,
    this.photoUrl,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'weight': weight,
      'measurements': measurements?.toMap(),
      'photoUrl': photoUrl,
      'notes': notes,
    };
  }

  factory ProgressEntry.fromMap(Map<String, dynamic> map) {
    return ProgressEntry(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      weight: map['weight']?.toDouble(),
      measurements: map['measurements'] != null
          ? BodyMeasurements.fromMap(map['measurements'])
          : null,
      photoUrl: map['photoUrl'],
      notes: map['notes'],
    );
  }

  ProgressEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    double? weight,
    BodyMeasurements? measurements,
    String? photoUrl,
    String? notes,
  }) {
    return ProgressEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      measurements: measurements ?? this.measurements,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
    );
  }
}
