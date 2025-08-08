import 'package:equatable/equatable.dart';

/// Exception thrown when a server error occurs.
class ServerException extends Equatable implements Exception {
  final String message;

  const ServerException({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Exception thrown when a cache error occurs.
class CacheException extends Equatable implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  List<Object?> get props => [message];
}