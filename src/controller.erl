-module(controller).
-export([start/2, wait_for_command/1, rpc/1]).
-record(state, {successor}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(Mod, Size) ->
  MasterPid = build_ring(Mod, Size, self()),
  register(master, MasterPid).

wait_for_command(State = #state{successor = Successor}) ->
  receive
    kill -> io:format("got kill~n",[]), Successor ! kill;
    Command -> 
      io:format("he said: ~p~n", [Command]),
      Successor ! Command,
      wait_for_command(State)
  end.
    
rpc(Command) -> master ! Command.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
build_ring(_Mod, 0, FirstInRing) -> FirstInRing;

build_ring(Mod, Size, Successor) ->
  NewPredecessor = spawn(fun() -> Mod:init(#state{successor=Successor}) end),
  build_ring(Mod, Size-1, NewPredecessor).


