%% Simple message of the day (MOTD) service.
%% Used to demonstrate hot code reloading: Start the service with init/0,
%% run get_msgs/0, then edit the loop message.
%% You'll see it change in the get_msgs/0 output.

-module(motd).

-export([init/0, get_msg/0, get_msgs/0, loop/0]).


%% Starts the motd service
init() ->
    register(motd, spawn(?MODULE, loop, [])).

%% Main loop - not called externally
loop() ->
    Message =  "This is a test",  % Edit this message while get_msgs() is running
    receive {FromPid, message} -> FromPid ! {message, Message} end,
    ?MODULE:loop().

%% Get a message from the service - not called externally
get_msg() ->
    motd ! {self(), message},
    receive {message, Message} -> Message
    after 5000 -> error
    end.

%% Client function which fetches a message every second.
%% Recompiles this module in case the message has changed.
get_msgs() ->
    io:format("~s~n", [get_msg()]),
    timer:sleep(1000),
    c:c(motd),
    ?MODULE:get_msgs().
