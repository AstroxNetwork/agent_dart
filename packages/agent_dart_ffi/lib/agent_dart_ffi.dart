import 'src/bridge_generated.dart' show Network;

export 'src/bridge_generated.dart';
export 'src/ffi.dart';

const _networkNameMap = {
  Network.Bitcoin: 'mainnet',
  Network.Testnet: 'testnet',
  Network.Regtest: 'regtest',
  Network.Signet: 'signet',
};

extension AgentDartFFIBitcoinNetworkExtension on Network {
  String get networkName => _networkNameMap[this]!;
}
