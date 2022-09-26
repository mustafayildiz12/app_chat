abstract class ICacheService<T> {
  Future<void> init();
  T? getValue();
  Future<void> setValue(T value);
  Future<void> clear();
}
