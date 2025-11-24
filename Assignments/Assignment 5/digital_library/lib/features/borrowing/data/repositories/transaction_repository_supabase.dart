import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/contracts/transaction_repository.dart';
import '../../domain/entities/transaction.dart';

class TransactionRepositorySupabase implements TransactionRepository {
  final SupabaseClient client;

  TransactionRepositorySupabase(this.client);

  Transaction _mapRow(dynamic row) => Transaction.fromJson(row);

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final data = await client.from('transactions').select().order('borrow_date');
    return data.map<Transaction>(_mapRow).toList();
  }

  @override
  Future<Transaction> getTransaction(String transactionId) async {
    final data = await client
        .from('transactions')
        .select()
        .eq('id', transactionId)
        .maybeSingle();
    if (data == null) throw Exception('Transaction with ID $transactionId not found');
    return _mapRow(data);
  }

  @override
  Future<List<Transaction>> getTransactionsByMember(String memberId) async {
    final data =
        await client.from('transactions').select().eq('member_id', memberId);
    return data.map<Transaction>(_mapRow).toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByBook(String bookId) async {
    final data =
        await client.from('transactions').select().eq('book_id', bookId);
    return data.map<Transaction>(_mapRow).toList();
  }

  @override
  Future<List<Transaction>> getActiveTransactions() async {
    final data =
        await client.from('transactions').select().eq('is_returned', false);
    return data.map<Transaction>(_mapRow).toList();
  }

  @override
  Future<List<Transaction>> getOverdueTransactions() async {
    final nowIso = DateTime.now().toIso8601String();
    final data = await client
        .from('transactions')
        .select()
        .lt('due_date', nowIso)
        .eq('is_returned', false);
    return data.map<Transaction>(_mapRow).toList();
  }

  // Streams
  @override
  Stream<List<Transaction>> watchAllTransactions() {
    return client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<Transaction?> watchTransaction(String transactionId) {
    return client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('id', transactionId)
        .map((rows) => rows.isNotEmpty ? _mapRow(rows.first) : null);
  }

  @override
  Stream<List<Transaction>> watchTransactionsByMember(String memberId) {
    return client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('member_id', memberId)
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<List<Transaction>> watchTransactionsByBook(String bookId) {
    return client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('book_id', bookId)
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<List<Transaction>> watchActiveTransactions() {
    return client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('is_returned', false)
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<List<Transaction>> watchOverdueTransactions() {
    return watchAllTransactions().map(
      (txs) => txs.where((t) => t.isOverdue()).toList(),
    );
  }

  // CRUD
  @override
  Future<void> addTransaction(Transaction transaction) async {
    await client.from('transactions').insert(transaction.toJson());
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    await client
        .from('transactions')
        .update(transaction.toJson())
        .eq('id', transaction.id);
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await client.from('transactions').delete().eq('id', transactionId);
  }
}
