-module(controller).
-export([start/2, wait_for_command/1]).
-record(state, {successor}).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% API
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(Mod, Size) ->
  build_ring(Mod, Size, self()).

wait_for_command(State = #state{successor = Successor}) ->
  receive
    kill -> io:format("got kill~n",[]), Successor ! kill;
    Command -> 
      Successor ! Command,
      wait_for_command(State)
  end.
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Helper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
build_ring(_Mod, 0, FirstInRing) -> FirstInRing;

build_ring(Mod, Size, Successor) ->
  NewPredecessor = spawn(fun() -> Mod:init(#state{successor=Successor}) end),
  build_ring(Mod, Size-1, NewPredecessor).


