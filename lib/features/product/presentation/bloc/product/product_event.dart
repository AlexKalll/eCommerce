part of 'product_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class ProductsLoadRequested extends ProductsEvent {}

class ProductsProductAdded extends ProductsEvent {
  final Product product;

  const ProductsProductAdded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductsProductUpdated extends ProductsEvent {
  final Product product;

  const ProductsProductUpdated(this.product);

  @override
  List<Object> get props => [product];
}

class ProductsProductDeleted extends ProductsEvent {
  final Product product;

  const ProductsProductDeleted(this.product);

  @override
  List<Object> get props => [product];
}