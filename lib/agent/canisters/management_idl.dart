import 'package:agent_dart/candid/idl.dart';

Service managementIDL() {
  const canisterId = IDL.Principal;
  final wasmModule = IDL.vec(IDL.Nat8);
  final canisterSettings = IDL.record({
    'compute_allocation': IDL.opt(IDL.Nat),
    'memory_allocation': IDL.opt(IDL.Nat),
  });
  return IDL.service({
    'provisional_create_canister_with_cycles': IDL.func(
      [
        IDL.record(
          {'amount': IDL.opt(IDL.Nat), 'settings': IDL.opt(canisterSettings)},
        )
      ],
      [
        IDL.record({'canister_id': canisterId})
      ],
      [],
    ),
    'create_canister': IDL.func(
      [],
      [
        IDL.record({'canister_id': canisterId})
      ],
      [],
    ),
    'install_code': IDL.func(
      [
        IDL.record({
          'mode': IDL.variant({
            'install': IDL.Null,
            'reinstall': IDL.Null,
            'upgrade': IDL.Null
          }),
          'canister_id': canisterId,
          'wasm_module': wasmModule,
          'arg': IDL.vec(IDL.Nat8),
        }),
      ],
      [],
      [],
    ),
    'set_controller': IDL.func(
      [
        IDL.record(
          {'canister_id': canisterId, 'new_controller': IDL.Principal},
        )
      ],
      [],
      [],
    ),
  });
}
