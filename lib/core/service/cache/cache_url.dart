import 'package:hive/hive.dart';

import 'i_cache_service.dart';

class CachedDomainHive extends ICacheService<String> {
  late Box<String> _baseApplicationConfig;

  @override
  Future<void> init() async {
    _baseApplicationConfig = await Hive.openBox(toString());
  }

  @override
  Future<void> clear() async {
    await _baseApplicationConfig.clear();
  }

  @override
  String? getValue() {
    final config =
        _baseApplicationConfig.get(CachedDomainHiveKey.imageUrl.name);

    return config;
  }

  @override
  Future<void> setValue(String value) async {
    await _baseApplicationConfig.put(CachedDomainHiveKey.imageUrl.name, value);
  }
}

enum CachedDomainHiveKey { imageUrl }
