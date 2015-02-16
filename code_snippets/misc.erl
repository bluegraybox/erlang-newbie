-module(misc).

-export([reassign/0, fetch/0]).

reassign() ->
    X = 1,
    X = 2.

fetch() ->
    inets:start(),
    Url = "http://bluegraybox.com/env.cgi",
    case httpc:request(Url) of
        {error, Message} -> io:format("error: ~s~n", [Message]);
        {ok, {{_Proto, 200, _Desc}, _Headers, _Content}} -> io:format("success~n");
        {ok, {{_Proto, Code, _Desc}, _Headers, _Content}} -> io:format("unexpected code: ~w~n", [Code]);
        Unexpected -> io:format("unexpected respose: ~w~n", [Unexpected])
    end.
