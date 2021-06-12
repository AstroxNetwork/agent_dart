import 'package:agent_dart/agent_dart.dart';

import 'init.dart';

class CounterMethod {
  static const add = "increment";
  static const count = "getValue";
}

final idl = IDL.Service({
  CounterMethod.count: IDL.Func([], [IDL.Nat], ['query']),
  CounterMethod.add: IDL.Func([], [], []),
});

class Counter extends ActorHook {
  Counter();
  factory Counter.create(CanisterActor _actor) {
    return Counter()..setActor(_actor);
  }
  setActor(CanisterActor _actor) {
    actor = _actor;
  }

  Future<int> count() async {
    try {
      var res = await actor.getFunc(CounterMethod.count)!([]);
      if (res != null) {
        return (res as BigInt).toInt();
      }
      throw "Cannot get count but $res";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> add() async {
    try {
      await actor.getFunc(CounterMethod.add)!([]);
    } catch (e) {
      rethrow;
    }
  }
}
