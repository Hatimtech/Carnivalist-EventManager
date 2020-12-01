import 'package:eventmanagement/service/network/network_service.dart';
import 'package:eventmanagement/service/viewmodel/mock_service.dart';

import '../restclient.dart';

enum Flavor { Testing, Network }

//Simple DI
class Injector {
  static final Injector _singleton = new Injector._internal();
  static Flavor _flavor;
  static NetworkService _networkService;

  static void configure(Flavor flavor) async {
    _flavor = flavor;
  }

  factory Injector() => _singleton;

  Injector._internal();

  get flavor {
    switch (_flavor) {
      case Flavor.Testing:
        return MockService();
      default:
        if (_networkService == null)
          _networkService = NetworkService(new RestClient());
        return _networkService;
    }
  }
}
