import '../../candid/idl.dart';

Service managementIDL() {
  const canisterId = IDL.Principal;
  final wasmModule = IDL.Vec(IDL.Nat8);
  final canisterSettings = IDL.Record({
    'compute_allocation': IDL.Opt(IDL.Nat),
    'memory_allocation': IDL.Opt(IDL.Nat),
  });
  return IDL.Service({
    'provisional_create_canister_with_cycles': IDL.Func(
      [
        IDL.Record(
          {'amount': IDL.Opt(IDL.Nat), 'settings': IDL.Opt(canisterSettings)},
        ),
      ],
      [
        IDL.Record({'canister_id': canisterId}),
      ],
      [],
    ),
    'create_canister': IDL.Func(
      [],
      [
        IDL.Record({'canister_id': canisterId}),
      ],
      [],
    ),
    'install_code': IDL.Func(
      [
        IDL.Record({
          'mode': IDL.Variant({
            'install': IDL.Null,
            'reinstall': IDL.Null,
            'upgrade': IDL.Null,
          }),
          'canister_id': canisterId,
          'wasm_module': wasmModule,
          'arg': IDL.Vec(IDL.Nat8),
        }),
      ],
      [],
      [],
    ),
    'set_controller': IDL.Func(
      [
        IDL.Record(
          {'canister_id': canisterId, 'new_controller': IDL.Principal},
        ),
      ],
      [],
      [],
    ),
  });
}
