-module(ring_worker).
-export([init/1]).
-import(controller, [wait_for_command/1]).

init(State) -> wait_for_command(State).
