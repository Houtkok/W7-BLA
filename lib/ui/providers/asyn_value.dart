import 'package:flutter/foundation.dart';

@immutable
class AsyncValue<T> {
  const AsyncValue._({
    this.data,
    this.error,
    this.isLoading = false,
  });

  final T? data;
  final Object? error;
  final bool isLoading;

  static AsyncValue<T> loading<T>() => AsyncValue<T>._(isLoading: true);

  static AsyncValue<T> success<T>(T data) => AsyncValue<T>._(data: data);

  static AsyncValue<T> errorValue<T>(Object error) => AsyncValue<T>._(error: error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AsyncValue<T> &&
        other.data == data &&
        other.error == error &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode => data.hashCode ^ error.hashCode ^ isLoading.hashCode;
}