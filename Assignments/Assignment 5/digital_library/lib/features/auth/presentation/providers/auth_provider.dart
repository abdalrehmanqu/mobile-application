import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'repo_providers.dart';
import '../../domain/contracts/auth_repository.dart';
import '../../domain/entities/staff.dart';

/// State class to hold authentication state
class AuthState {
  final Staff? currentStaff;
  final bool isAuthenticated;
  final String? errorMessage;

  AuthState({
    this.currentStaff,
    this.isAuthenticated = false,
    this.errorMessage,
  });

  AuthState copyWith({
    Staff? currentStaff,
    bool? isAuthenticated,
    String? errorMessage,
  }) {
    return AuthState(
      currentStaff: currentStaff ?? this.currentStaff,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier for managing authentication state
class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository _authRepo;

  @override
  Future<AuthState> build() async {
    // Get the repository from the provider
    _authRepo = await ref.read(authRepoProvider.future);

    // If there's an active session, hydrate the user
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      final user = session.user;
      final staff = (await _authRepo.getStaffByUsername(user.email ?? '')) ??
          Staff(
            staffId: user.id,
            username: user.email ?? '',
            password: '',
            fullName: user.userMetadata?['full_name']?.toString() ?? 'Staff',
            role: user.userMetadata?['role']?.toString() ?? 'staff',
          );
      return AuthState(
        currentStaff: staff,
        isAuthenticated: true,
      );
    }

    // Initialize with unauthenticated state
    return AuthState();
  }

  /// Authenticate a staff member
  Future<bool> authenticate(String username, String password) async {
    state = const AsyncValue.loading();

    try {
      // Get repository from provider (in case build() hasn't completed yet)
      final authRepo = await ref.read(authRepoProvider.future);
      final staff = await authRepo.authenticate(username, password);

      if (staff != null) {
        state = AsyncValue.data(
          AuthState(
            currentStaff: staff,
            isAuthenticated: true,
          ),
        );
        return true;
      } else {
        state = AsyncValue.data(
          AuthState(
            errorMessage: 'Invalid email or password',
          ),
        );
        return false;
      }
    } on AuthException catch (e) {
      state = AsyncValue.data(
        AuthState(errorMessage: e.message),
      );
      return false;
    } catch (e) {
      state = AsyncValue.data(AuthState(errorMessage: e.toString()));
      return false;
    }
  }

  /// Logout the current staff member
  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    state = AsyncValue.data(AuthState());
  }

  /// Sign up a new staff user with Supabase auth
  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final client = Supabase.instance.client;
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'role': 'staff'},
      );

      final user = response.user;
      if (user != null) {
        try {
          await client.from('staff').upsert({
            'staff_id': user.id,
            'username': email,
            'full_name': fullName,
            'role': 'staff',
          });
        } on PostgrestException {
          // If staff table does not exist, skip silently; auth metadata still holds name/role.
        }
      }

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  /// Get current staff (convenience method)
  Staff? get currentStaff => state.value?.currentStaff;

  /// Check if user is authenticated (convenience method)
  bool get isAuthenticated => state.value?.isAuthenticated ?? false;
}

/// Provider for auth notifier
final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(),
);
