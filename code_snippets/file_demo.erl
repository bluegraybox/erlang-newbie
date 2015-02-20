-module(file_demo).

-export([get_term/0, get_bin/0, get_missing/0, write_war/1, writebot/3]).

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

writebot(_FileHandle, 0, Parent) ->
    Parent ! ok;
writebot(FileHandle, Count, Parent) ->
    file:write(FileHandle, io_lib:format("~w, ", [Count])),
    writebot(FileHandle, Count - 1, Parent).

write_war(Filename) ->
    {ok, F} = file:open(Filename, [write]),
    spawn(?MODULE, writebot, [F, 100, self()]),
    spawn(?MODULE, writebot, [F, 100, self()]),
    spawn(?MODULE, writebot, [F, 100, self()]),
    receive ok -> ok end,
    receive ok -> ok end,
    receive ok -> ok end,
    io:format("Cleaning up~n"),
    file:close(F).
