import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/activity.dart';
import '../providers/activity_provider.dart';

class ActivitiesByTripScreen extends ConsumerStatefulWidget {
  final int tripId;
  final String tripName;

  const ActivitiesByTripScreen({
    super.key,
    required this.tripId,
    required this.tripName,
  });

  @override
  ConsumerState<ActivitiesByTripScreen> createState() =>
      _ActivitiesByTripScreenState();
}

class _ActivitiesByTripScreenState
    extends ConsumerState<ActivitiesByTripScreen> {
  List<Activity?> _activities = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final notifier = ref.read(activityNotifierProvider.notifier);
      final activities = await notifier.getActivitiesByTrip(widget.tripId);
      setState(() {
        _activities = activities;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripName),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/trip/${widget.tripId}/add-activity');
          _loadActivities();
        },
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadActivities,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_activities.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checklist_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No activities yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to add a new activity',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadActivities,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          if (activity == null) return const SizedBox.shrink();
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: activity.isCompleted
                    ? Colors.green.shade100
                    : Colors.orange.shade100,
                child: Icon(
                  activity.isCompleted ? Icons.check_circle : Icons.pending,
                  color: activity.isCompleted
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
              ),
              title: Text(
                activity.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: activity.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(activity.description),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: activity.isCompleted
                          ? Colors.green.shade100
                          : Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      activity.isCompleted ? 'Completed' : 'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        color: activity.isCompleted
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      activity.isCompleted ? Icons.undo : Icons.check,
                      color: Colors.teal,
                    ),
                    onPressed: () async {
                      final updatedActivity = activity.copyWith(
                        isCompleted: !activity.isCompleted,
                      );
                      final notifier = ref.read(
                        activityNotifierProvider.notifier,
                      );
                      await notifier.updateActivity(activity);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Activity'),
                          content: Text(
                            'Are you sure you want to delete "${activity.title}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        final notifier = ref.read(
                          activityNotifierProvider.notifier,
                        );
                        await notifier.deleteActivity(activity);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
