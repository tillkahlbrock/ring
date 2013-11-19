-module(controller).
-export([start/2, rpc/1]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(Mod, Size) ->
  MasterPid = build_ring(Mod, Size, self()),
  register(master, MasterPid).

wait_for_command(Mod, Successor) ->
  receive
    kill -> io:format("got kill~n",[]), Successor ! kill;
    Command -> 
      Mod:handle(Command),
      Successor ! Command,
      wait_for_command(Mod, Successor)
  end.
    
rpc(Command) -> master ! Command.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
build_ring(_Mod, 0, FirstInRing) -> FirstInRing;

build_ring(Mod, Size, Successor) ->
  NewPredecessor = spawn(fun() -> wait_for_command(Mod, Successor) end),
  build_ring(Mod, Size-1, NewPredecessor).


