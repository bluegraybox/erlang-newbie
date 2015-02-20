-module(divsvc).

-export([init/0, supervisor/0, div_loop/0, get_div/2, get_div/3]).

-define(SVC_NAME, divsvc).


init() ->
    spawn(?MODULE, supervisor, []).

supervisor() ->
    process_flag(trap_exit, true),
    DivPid = spawn_link(?MODULE, div_loop, []),
    io:format("started divsvc with pid=~w~n", [DivPid]),
    register(?SVC_NAME, DivPid),
    supervisor_loop().

supervisor_loop() ->
    receive
        {'EXIT', _Pid, _Reason} ->
            DivPid = spawn_link(?MODULE, div_loop, []),
            register(?SVC_NAME, DivPid),
            io:format("restarted divsvc with pid=~w~n", [DivPid])
    end,
    supervisor_loop().

div_loop() ->
    receive {FromPid, X, Y} -> FromPid ! X/Y end,
    div_loop().

get_div(X, Y) ->
    rdiv(?SVC_NAME, X, Y).

get_div(Node, X, Y) ->
    rdiv({?SVC_NAME, Node}, X, Y).

rdiv(Svc, X, Y) ->
    Svc ! {self(), X, Y},
    receive Resp -> Resp
    after 3000 -> {error, "Timed out"}
    end.
