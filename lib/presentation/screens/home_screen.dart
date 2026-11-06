import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../data/models/exercise.dart';
import '../../data/models/fact.dart';
import '../../data/repositories/info_repository.dart';
import 'exercise_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _repository = getIt<InfoRepository>();

  String _muscle = 'biceps';
  String _difficulty = '';
  bool _loadingExercises = false;
  bool _loadingFact = false;
  String? _error;
  List<Exercise> _exercises = [];
  Fact? _fact;

  static const _muscles = <String, String>{
    'biceps': 'Бицепс',
    'chest': 'Грудь',
    'abdominals': 'Пресс',
    'back': 'Спина',
    'glutes': 'Ягодицы',
    'quadriceps': 'Квадрицепсы',
    'triceps': 'Трицепс',
    'hamstrings': 'Бицепс бедра',
  };

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _loadFact();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFact() async {
    setState(() => _loadingFact = true);
    try {
      final result = await _repository.getRandomFact();
      if (!mounted) return;
      setState(() => _fact = result);
    } catch (_) {
      if (!mounted) return;
      setState(() => _fact = const Fact(
        text: 'Не удалось загрузить факт. Проверьте API-ключ и интернет.',
      ));
    } finally {
      if (mounted) setState(() => _loadingFact = false);
    }
  }

  Future<void> _loadExercises() async {
    setState(() {
      _loadingExercises = true;
      _error = null;
    });
    try {
      final result = await _repository.getExercises(
        muscle: _muscle,
        name: _searchController.text,
        difficulty: _difficulty,
      );
      if (!mounted) return;
      setState(() => _exercises = result);
    } on DioException catch (error) {
      if (!mounted) return;
      final status = error.response?.statusCode;
      setState(() {
        _error = status == 401 || status == 403
            ? 'API-ключ не принят. Проверьте его в service_locator.dart.'
            : status == 429
                ? 'Лимит запросов API исчерпан. Попробуйте позже.'
                : 'Не удалось подключиться. Проверьте интернет и API-ключ.';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = 'Ошибка загрузки: $error');
    } finally {
      if (mounted) setState(() => _loadingExercises = false);
    }
  }

  void _openExercise(Exercise exercise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InfoHub',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            onPressed: () {
              _loadExercises();
              _loadFact();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([_loadExercises(), _loadFact()]);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
          children: [
            const Text(
              'Тренируйся и узнавай новое',
              style: TextStyle(fontSize: 17, color: Colors.black54),
            ),
            const SizedBox(height: 18),
            _buildFactCard(),
            const SizedBox(height: 24),
            const Text(
              'Каталог упражнений',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _loadExercises(),
              decoration: InputDecoration(
                hintText: 'Например, curl или press',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _loadExercises,
                  icon: const Icon(Icons.arrow_forward),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _muscle,
              decoration: InputDecoration(
                labelText: 'Группа мышц',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _muscles.entries
                  .map((entry) => DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _muscle = value);
                _loadExercises();
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _difficulty,
              decoration: InputDecoration(
                labelText: 'Сложность',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(value: '', child: Text('Любая')),
                DropdownMenuItem(value: 'beginner', child: Text('Начальный')),
                DropdownMenuItem(value: 'intermediate', child: Text('Средний')),
                DropdownMenuItem(value: 'expert', child: Text('Продвинутый')),
              ],
              onChanged: (value) {
                setState(() => _difficulty = value ?? '');
                _loadExercises();
              },
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Результаты',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                Text('${_exercises.length} найдено',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 10),
            if (_loadingExercises)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              _buildError()
            else if (_exercises.isEmpty)
              const Padding(
                padding: EdgeInsets.all(22),
                child: Center(child: Text('Ничего не найдено. Измените запрос.')),
              )
            else
              ..._exercises.map(_buildExerciseCard),
          ],
        ),
      ),
    );
  }

  Widget _buildFactCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF536DFE), Color(0xFF7986FF)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Случайный факт',
                    style: TextStyle(color: Colors.white, fontSize: 17,
                        fontWeight: FontWeight.bold)),
              ),
              IconButton(
                onPressed: _loadingFact ? null : _loadFact,
                icon: const Icon(Icons.autorenew, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_loadingFact)
            const LinearProgressIndicator()
          else
            Text(
              _fact?.text ?? 'Загружаем интересный факт...',
              style: const TextStyle(color: Colors.white, fontSize: 15,
                  height: 1.45),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8EAFE),
          child: const Icon(Icons.fitness_center, color: Color(0xFF536DFE)),
        ),
        title: Text(exercise.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${exercise.muscle} • ${exercise.difficulty}',
            maxLines: 2,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _openExercise(exercise),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _loadExercises,
            icon: const Icon(Icons.refresh),
            label: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
