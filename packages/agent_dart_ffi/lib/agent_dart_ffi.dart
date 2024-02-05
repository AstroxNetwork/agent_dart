import 'src/bridge_generated.dart' show Network;

export 'src/bridge_generated.dart';
export 'src/ffi.dart';

const _networkNameMap = <Network, Set<String>>{
  Network.Bitcoin: {'livenet', 'mainnet'},
  Network.Testnet: {'testnet'},
  Network.Regtest: {'regtest'},
  Network.Signet: {'signet'},
};

extension AgentDartFFIBitcoinNetworkExtension on Network {
  String get networkName => _networkNameMap[this]!.first;

  bool matches(String? name) => _networkNameMap[this]!.contains(name);
}
