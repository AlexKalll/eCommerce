part of 'product_bloc.dart';

sealed class ProductsState extends Equatable {
  final List<Product> products;

  const ProductsState(this.products);

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial(super.products);
}

class ProductsLoadSuccess extends ProductsState {
  const ProductsLoadSuccess(super.products);
}

class ProductsLoadInProgress extends ProductsState {
  const ProductsLoadInProgress(super.products);
}

class ProductsAddInProgress extends ProductsState {
  const ProductsAddInProgress(super.products);
}

class ProductsAddSuccess extends ProductsState {
  final Product addedProduct;

  const ProductsAddSuccess(this.addedProduct, super.products);
}

class ProductsUpdateInProgress extends ProductsState {
  const ProductsUpdateInProgress(super.products);
}

class ProductsUpdateSuccess extends ProductsState {
  const ProductsUpdateSuccess(super.products);
}

class ProductsDeleteInProgress extends ProductsState {
  const ProductsDeleteInProgress(super.products);
}

class ProductsDeleteSuccess extends ProductsState {
  final String deletedProductName;

  const ProductsDeleteSuccess(this.deletedProductName, super.products);
}

class ProductsFailure extends ProductsState {
  final String message;

  const ProductsFailure(this.message, super.products);
}