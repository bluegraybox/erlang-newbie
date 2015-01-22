-module(autoinc).

-compile([]).

-export([init/0, init/1, next/1, loop/1]).


loop(Id) ->
    receive
        {FromPid, next} ->
            FromPid ! {id, Id},
            loop(Id + 1);
        quit -> ok
    end.

init() ->
    spawn(?MODULE, loop, [1]).

init(Name) ->
    case whereis(Name) of
        undefined ->
            Pid = spawn(?MODULE, loop, [1]),
            register(Name, Pid);
        _Pid -> ok
    end.

next(Pid) ->
    Pid ! {self(), next},
    receive {id, Id} -> Id
    after 5000 -> error
    end.
