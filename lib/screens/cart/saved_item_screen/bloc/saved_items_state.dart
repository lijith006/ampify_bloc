part of 'saved_items_bloc.dart';

abstract class SavedItemsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SavedItemsLoading extends SavedItemsState {}

class SavedItemsLoaded extends SavedItemsState {
  final List<CartItem> savedItems;

  SavedItemsLoaded(this.savedItems);

  @override
  List<Object> get props => [savedItems];
}

class SavedItemsError extends SavedItemsState {
  final String message;

  SavedItemsError(this.message);

  @override
  List<Object> get props => [message];
}
