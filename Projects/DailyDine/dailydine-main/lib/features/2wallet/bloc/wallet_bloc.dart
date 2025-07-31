import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/models/wallet_model.dart';

// Events
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWallet extends WalletEvent {
  const LoadWallet();
}

class AddMoney extends WalletEvent {
  final double amount;
  
  const AddMoney(this.amount);

  @override
  List<Object?> get props => [amount];
}

class WithdrawMoney extends WalletEvent {
  final double amount;
  
  const WithdrawMoney(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateWalletBalance extends WalletEvent {
  final double newBalance;
  
  const UpdateWalletBalance(this.newBalance);

  @override
  List<Object?> get props => [newBalance];
}

// States
abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletModel wallet;
  final List<TransactionModel> transactions;

  const WalletLoaded({
    required this.wallet,
    required this.transactions,
  });

  @override
  List<Object?> get props => [wallet, transactions];

  WalletLoaded copyWith({
    WalletModel? wallet,
    List<TransactionModel>? transactions,
  }) {
    return WalletLoaded(
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
    );
  }
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<LoadWallet>(_onLoadWallet);
    on<AddMoney>(_onAddMoney);
    on<WithdrawMoney>(_onWithdrawMoney);
    on<UpdateWalletBalance>(_onUpdateWalletBalance);
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<WalletState> emit,
  ) async {
    emit(WalletLoading());
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock wallet data
      final wallet = WalletModel(
        id: '1',
        userId: '1',
        balance: 0.0,
        currency: 'USD',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final transactions = <TransactionModel>[];

      emit(WalletLoaded(wallet: wallet, transactions: transactions));
    } catch (e) {
      emit(WalletError('Failed to load wallet: $e'));
    }
  }

  Future<void> _onAddMoney(
    AddMoney event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is WalletLoaded) {
        final newBalance = currentState.wallet.balance + event.amount;
        final updatedWallet = currentState.wallet.copyWith(
          balance: newBalance,
          updatedAt: DateTime.now(),
        );

        final newTransaction = TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          walletId: updatedWallet.id,
          type: 'credit',
          amount: event.amount,
          description: 'Money added to wallet',
          status: 'completed',
          createdAt: DateTime.now(),
        );

        final updatedTransactions = [newTransaction, ...currentState.transactions];

        emit(currentState.copyWith(
          wallet: updatedWallet,
          transactions: updatedTransactions,
        ));
      }
    } catch (e) {
      emit(WalletError('Failed to add money: $e'));
    }
  }

  Future<void> _onWithdrawMoney(
    WithdrawMoney event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is WalletLoaded) {
        if (currentState.wallet.balance < event.amount) {
          emit(WalletError('Insufficient balance'));
          return;
        }

        final newBalance = currentState.wallet.balance - event.amount;
        final updatedWallet = currentState.wallet.copyWith(
          balance: newBalance,
          updatedAt: DateTime.now(),
        );

        final newTransaction = TransactionModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          walletId: updatedWallet.id,
          type: 'debit',
          amount: event.amount,
          description: 'Money withdrawn from wallet',
          status: 'completed',
          createdAt: DateTime.now(),
        );

        final updatedTransactions = [newTransaction, ...currentState.transactions];

        emit(currentState.copyWith(
          wallet: updatedWallet,
          transactions: updatedTransactions,
        ));
      }
    } catch (e) {
      emit(WalletError('Failed to withdraw money: $e'));
    }
  }

  Future<void> _onUpdateWalletBalance(
    UpdateWalletBalance event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is WalletLoaded) {
        final updatedWallet = currentState.wallet.copyWith(
          balance: event.newBalance,
          updatedAt: DateTime.now(),
        );

        emit(currentState.copyWith(wallet: updatedWallet));
      }
    } catch (e) {
      emit(WalletError('Failed to update wallet balance: $e'));
    }
  }
}


