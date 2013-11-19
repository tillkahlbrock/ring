-module(ring_worker).
-export([init/1, measure/1]).
-import(controller, [wait_for_command/1, rpc/1]).

init(State) -> wait_for_command(State).

measure(Roundtrips) -> rpc({measure, Roundtrips}).
