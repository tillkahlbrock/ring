-module(ring_worker).
-export([measure/1, handle/1]).
-import(controller, [rpc/1]).

handle({measure, Param}) -> io:format("got measure command with param ~p~n", [Param]).

measure(Roundtrips) -> rpc({measure, Roundtrips}).
