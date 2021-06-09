import 'package:agent_dart/candid/idl.dart';

Service assetIDL() {
  return IDL.Service({
    "retrieve": IDL.Func([IDL.Text], [IDL.Vec(IDL.Nat8)], ['query']),
    "store": IDL.Func([IDL.Text, IDL.Vec(IDL.Nat8)], [], []),
  });
}
