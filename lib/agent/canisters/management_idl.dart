import 'package:agent_dart/candid/idl.dart';

Service managementIDL() {
  // ignore: non_constant_identifier_names
  final canister_id = IDL.Principal;
  // ignore: non_constant_identifier_names
  final wasm_module = IDL.Vec(IDL.Nat8);
  // ignore: non_constant_identifier_names
  final CanisterSettings = IDL.Record({
    "compute_allocation": IDL.Opt(IDL.Nat),
    "memory_allocation": IDL.Opt(IDL.Nat),
  });
  return IDL.Service({
    "provisional_create_canister_with_cycles": IDL.Func(
      [
        IDL.Record({"amount": IDL.Opt(IDL.Nat), "settings": IDL.Opt(CanisterSettings)})
      ],
      [
        IDL.Record({"canister_id": canister_id})
      ],
      [],
    ),
    "create_canister": IDL.Func([], [
      IDL.Record({"canister_id": canister_id})
    ], []),
    "install_code": IDL.Func(
      [
        IDL.Record({
          "mode": IDL.Variant({"install": IDL.Null, "reinstall": IDL.Null, "upgrade": IDL.Null}),
          "canister_id": canister_id,
          "wasm_module": wasm_module,
          "arg": IDL.Vec(IDL.Nat8),
        }),
      ],
      [],
      [],
    ),
    "set_controller": IDL.Func(
      [
        IDL.Record({"canister_id": canister_id, "new_controller": IDL.Principal})
      ],
      [],
      [],
    ),
  });
}
