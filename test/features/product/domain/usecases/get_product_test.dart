import 'package:dartz/dartz.dart';
import 'package:ecommerce/features/product/domain/entities/product.dart';
import 'package:ecommerce/features/product/domain/repositories/product_repository.dart';
import 'package:ecommerce/features/product/domain/usecases/get_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_product_test.mocks.dart';

@GenerateMocks([ProductRepository])
void main() {
  late GetProduct getProduct;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    getProduct = GetProduct(mockProductRepository);
  });

  test('should get product from the repository', () async {
    // arrange
    const tId = 'id';
    const tProduct = Product(
        id: tId,
        name: 'name',
        description: 'description',
        price: 123.45,
        imageUrl: 'https://product.image.com/id');

    when(mockProductRepository.getProduct(tId))
        .thenAnswer((_) async => const Right(tProduct));

    // act
    final result = await getProduct(const GetProductParams(tId));

    // assert
    expect(result, const Right(tProduct));
    verify(mockProductRepository.getProduct(tId));
    verifyNoMoreInteractions(mockProductRepository);
  });
}
