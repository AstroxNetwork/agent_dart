import 'src/bdk/types.dart' show Network;

export 'src/api.dart';
export 'src/bdk/blockchain.dart';
export 'src/bdk/types.dart';
export 'src/bdk/wallet.dart';
export 'src/frb_generated.dart' show RustLib;
export 'src/lib.dart';
export 'src/p256.dart';
export 'src/schnorr.dart';
export 'src/secp256k1.dart';
export 'src/types.dart';

const _networkNameMap = <Network, Set<String>>{
  Network.bitcoin: {'livenet', 'mainnet'},
  Network.testnet: {'testnet'},
  Network.regtest: {'regtest'},
  Network.signet: {'signet'},
};

extension AgentDartFFIBitcoinNetworkExtension on Network {
  String get networkName => _networkNameMap[this]!.first;

  bool matches(String? name) => _networkNameMap[this]!.contains(name);
}
