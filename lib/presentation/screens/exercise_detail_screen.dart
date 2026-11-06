import 'package:flutter/material.dart';
import '../../data/models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  const ExerciseDetailScreen({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Упражнение')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAFE),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.fitness_center,
                size: 76, color: Color(0xFF536DFE)),
          ),
          const SizedBox(height: 20),
          Text(exercise.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(exercise.muscle),
              _chip(exercise.type),
              _chip(exercise.difficulty),
            ],
          ),
          const SizedBox(height: 24),
          _section('Как выполнять', exercise.instructions),
          const SizedBox(height: 18),
          _section(
            'Оборудование',
            exercise.equipments.isEmpty
                ? 'Специальное оборудование не указано.'
                : exercise.equipments.join(', '),
          ),
          const SizedBox(height: 18),
          _section('Безопасность', exercise.safetyInfo),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: const Color(0xFFE8EAFE),
      side: BorderSide.none,
    );
  }

  Widget _section(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(fontSize: 15, height: 1.5)),
      ],
    );
  }
}
