import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/author_repository_impl.dart';
import '../../data/repositories/library_repository_impl.dart';
import '../../domain/contracts/author_repository.dart';
import '../../domain/contracts/library_repository.dart';

/// Library Repository Provider
/// Provides access to the library items repository
/// Uses FutureProvider to support async initialization (for future database integration)
final libraryRepoProvider = FutureProvider<LibraryRepository>((ref) async {
  return LibraryRepositoryImpl(Supabase.instance.client);
});

/// Author Repository Provider
/// Provides access to the authors repository
/// Uses FutureProvider to support async initialization (for future database integration)
final authorRepositoryProvider = FutureProvider<AuthorRepository>((ref) async {
  return AuthorRepositoryImpl(Supabase.instance.client);
});
