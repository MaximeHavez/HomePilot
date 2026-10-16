import 'package:flutter/material.dart';

import '../models/task.dart';

class HomePilotHomePage extends StatefulWidget {
  const HomePilotHomePage({
    super.key,
    required this.tasks,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onAddTask,
  });

  final List<Task> tasks;
  final void Function(String) onToggleTask;
  final void Function(String) onDeleteTask;
  final Future<void> Function() onAddTask;

  @override
  State<HomePilotHomePage> createState() => _HomePilotHomePageState();
}

class _HomePilotHomePageState extends State<HomePilotHomePage> {
  String _selectedFilter = 'Tous';

  List<Task> get filteredTasks {
    switch (_selectedFilter) {
      case 'À faire':
        return widget.tasks.where((task) => !task.done).toList();
      case 'Terminées':
        return widget.tasks.where((task) => task.done).toList();
      case 'Tous':
      default:
        return widget.tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = widget.tasks.length;
    final doneTasks = widget.tasks.where((task) => task.done).length;
    final remainingTasks = totalTasks - doneTasks;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonjour !',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Le foyer est bien organisé',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tâches du foyer',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total',
                    value: '$totalTasks',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'À faire',
                    value: '$remainingTasks',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Terminé',
                    value: '$doneTasks',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Tous', label: Text('Tous')),
                ButtonSegment(value: 'À faire', label: Text('À faire')),
                ButtonSegment(value: 'Terminées', label: Text('Terminées')),
              ],
              selected: {_selectedFilter},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedFilter = selection.first;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(child: Text('Aucune tâche pour ce filtre.'))
                  : ListView.separated(
                      itemCount: filteredTasks.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return Material(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          elevation: 1,
                          child: CheckboxListTile(
                            value: task.done,
                            onChanged: (_) => widget.onToggleTask(task.id),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.done
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(task.room),
                            secondary: IconButton(
                              onPressed: () => widget.onDeleteTask(task.id),
                              icon: const Icon(Icons.delete_outline),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
