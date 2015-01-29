-module(motd).

-export([init/0, get_msg/0, get_msgs/0, loop/0]).


loop() ->
    Message =  "This is a different test",
    receive {FromPid, message} -> FromPid ! {message, Message} end,
    ?MODULE:loop().

init() ->
    register(motd, spawn(?MODULE, loop, [])).

get_msg() ->
    motd ! {self(), message},
    receive {message, Message} -> Message
    after 5000 -> error
    end.

get_msgs() ->
    io:format("~s~n", [get_msg()]),
    timer:sleep(1000),
    ?MODULE:get_msgs().
