class Exercise {
  const Exercise({
    required this.name,
    required this.type,
    required this.muscle,
    required this.difficulty,
    required this.instructions,
    required this.equipments,
    required this.safetyInfo,
  });

  final String name;
  final String type;
  final String muscle;
  final String difficulty;
  final String instructions;
  final List<String> equipments;
  final String safetyInfo;

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final equipmentData = json['equipments'];
    return Exercise(
      name: json['name']?.toString() ?? 'Unknown exercise',
      type: json['type']?.toString() ?? 'Not specified',
      muscle: json['muscle']?.toString() ?? 'Not specified',
      difficulty: json['difficulty']?.toString() ?? 'Not specified',
      instructions: json['instructions']?.toString() ?? 'No instructions',
      equipments: equipmentData is List
          ? equipmentData.map((item) => item.toString()).toList()
          : <String>[],
      safetyInfo: json['safety_info']?.toString() ?? 'Follow safe technique.',
    );
  }
}
