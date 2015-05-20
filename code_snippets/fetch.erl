#!/usr/local/bin/escript
%%! -smp enable -sname divserver

%% Simple URL fetcher

main([Url]) ->
    inets:start(),
    Output = case httpc:request(Url) of
        {error, Message} -> io_lib:format("error: ~s~n", [Message]);
        {ok, {{_Proto, 200, _Desc}, _Headers, Content}} -> Content;
        {ok, {{_Proto, Code, Desc}, _Headers, _Content}} -> io_lib:format("Unexpected response: ~w [~s]~n", [Code, Desc]);
        Unexpected -> io:format("Unexpected respose: ~w~n", [Unexpected])
    end,
    io:fwrite(Output).
