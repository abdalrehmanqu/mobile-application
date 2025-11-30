import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/trip.dart';
import '../providers/trip_provider.dart';

class EditTripScreen extends ConsumerStatefulWidget {
  final int? tripId;

  const EditTripScreen({super.key, this.tripId});

  @override
  ConsumerState<EditTripScreen> createState() => _EditTripScreenState();
}

class _EditTripScreenState extends ConsumerState<EditTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool _isLoading = false;
  bool _isEditing = false;
  Trip? _existingTrip;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.tripId != null;
    if (_isEditing) {
      _loadTrip();
    }
  }

  Future<void> _loadTrip() async {
    setState(() => _isLoading = true);
    try {
      final trip = await ref
          .read(tripsProvider.notifier)
          .getTripById(widget.tripId!);
      if (trip != null) {
        _existingTrip = trip;
        _nameController.text = trip.name;
        _destinationController.text = trip.destination;
        _startDateController.text = trip.startDate;
        _endDateController.text = trip.endDate;
        _imageUrlController.text = trip.imageUrl;
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final trip = Trip(
        id: _existingTrip?.id,
        name: _nameController.text.trim(),
        destination: _destinationController.text.trim(),
        startDate: _startDateController.text.trim(),
        endDate: _endDateController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=400'
            : _imageUrlController.text.trim(),
      );

      if (_isEditing) {
        ref.read(tripsProvider.notifier).updateTrip(trip);
      } else {
        ref.read(tripsProvider.notifier).addTrip(trip);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Trip updated successfully'
                  : 'Trip added successfully',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Trip' : 'Add Trip'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _isEditing && _existingTrip == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Trip Name',
                        hintText: 'Enter trip name',
                        prefixIcon: Icon(Icons.flight),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter trip name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _destinationController,
                      decoration: const InputDecoration(
                        labelText: 'Destination',
                        hintText: 'Enter destination (e.g., Paris, France)',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter destination';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        hintText: 'Enter start date (YYYY-MM-DD)',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter start date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        hintText: 'Enter end date (YYYY-MM-DD)',
                        prefixIcon: Icon(Icons.event),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter end date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL (optional)',
                        hintText: 'Enter image URL',
                        prefixIcon: Icon(Icons.image),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveTrip,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_isEditing ? 'Update Trip' : 'Add Trip'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
