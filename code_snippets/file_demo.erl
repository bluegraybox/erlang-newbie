-module(file_demo).

-export([get_term/0, get_bin/0, get_missing/0]).

get_term() ->
    Contents = case file:consult("data.erl") of
        {error, _Msg} -> [];
        {ok, [Text]} -> Text;
        {ok, _Unexpected} -> []
    end,
    io:format("Contents: ~s~n", [Contents]).

get_bin() ->
    get_bin("data.erl").

get_missing() ->
    get_bin("missing.erl").

get_bin(Filename) ->
    Contents = case file:read_file(Filename) of
        {error, _Msg} -> "";
        {ok, Bytes} -> Bytes
    end,
    io:format("Contents: '~s'~n", [Contents]).
