// lib/ui/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/chore.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<AppState>().reload(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatChip(label: 'Roommates', value: app.roommatesCount),
              _StatChip(label: 'Chores', value: app.choresCount),
              _StatChip(label: 'Penalties', value: app.penaltiesCount),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.read<AppState>().assignAllPending(),
            icon: const Icon(Icons.assignment_ind_outlined),
            label: const Text('Assign all pending chores'),
          ),
          const SizedBox(height: 24),
          const Text('Next due chores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          if (app.nextDue.isEmpty)
            const Text('No pending chores — nice!', style: TextStyle(fontStyle: FontStyle.italic))
          else
            ...app.nextDue.map((c) => _ChoreCard(chore: c)),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      avatar: CircleAvatar(child: Text(value.toString())),
      label: Text(label),
    );
  }
}

class _ChoreCard extends StatelessWidget {
  final Chore chore;
  const _ChoreCard({required this.chore});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(chore.title),
        subtitle: Text(
          'due: ${chore.dueDate}\nassigned: ${app.nameFor(chore.assignedTo)} • status: ${chore.status.name}',
        ),
        trailing: Wrap(spacing: 8, children: [
          TextButton(
            onPressed: () => context.read<AppState>().markDone(chore.id),
            child: const Text('Done'),
          ),
          TextButton(
            onPressed: () => context.read<AppState>().markMissed(chore.id),
            child: const Text('Missed'),
          ),
        ]),
      ),
    );
  }
}
