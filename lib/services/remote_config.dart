import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:noor/services/prefs.dart';

class RemoteConfigService {
  final RemoteConfig _remoteConfig = RemoteConfig.instance;
  Duration minimumFetchInterval = const Duration(hours: 1);
  Duration timeout = const Duration(seconds: 10);

  static RemoteConfigService instance = RemoteConfigService._();

  RemoteConfigService._() {
    SharedPrefsService.putBool('CONFIG_STATE', true);

    _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        minimumFetchInterval: minimumFetchInterval,
        fetchTimeout: timeout,
      ),
    );

    _remoteConfig.setDefaults(<String, dynamic>{
      'noorThker': 'قال تعالى: ﴿فَاذكُروني أَذكُركُم ﴾ [البقرة: ١٥٢]',
    });
  }

  Future<String> fetchNoorRC() async {
    if (SharedPrefsService.getBool('CONFIG_STATE')) {
      SharedPrefsService.putBool('CONFIG_STATE', false);

      try {
        await _remoteConfig.fetchAndActivate();
      } catch (e) {
        print(e);
      }
    }
    return _remoteConfig.getString('noorThker');
  }
}
