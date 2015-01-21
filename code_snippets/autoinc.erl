-module(autoinc).

-export([init/0, init/1, next/1, loop/1]).

loop(Id) ->
    receive
        {FromPid, next} ->
            FromPid ! Id,
            ?MODULE:loop(Id + 1)
    end.

init() ->
    %% spawn(fun() -> loop(1) end).
    spawn(?MODULE, loop, [1]).

init(Name) ->
    case whereis(Name) of
        undefined ->
            Pid = spawn(fun() -> loop(1) end),
            register(Name, Pid);
        _Pid -> ok
    end.

next(Pid) ->
    Pid ! {self(), next},
    receive Resp -> Resp
    after 5000 -> error
    end.
