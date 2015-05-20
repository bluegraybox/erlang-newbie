#!/usr/local/bin/escript
%%! -smp enable -sname mydiv

%% Command-line utility for doing division.

-mode(compile).  % for better performance

%% mydiv/2 - the function we really care about
mydiv(_X, 0) -> {error, "Divide by zero, dumbass."};
mydiv(X, Y) -> {X div Y, X rem Y}.


%% Command line invocation
main([Xstr, Ystr]) ->
    X = parseInt(Xstr),
    Y = parseInt(Ystr),
    if
        X /= error, Y /= error -> display(X, Y, mydiv(X, Y));
        true -> error
    end;
main(_) ->
    io:format("Usage: ~s X Y~n", [escript:script_name()]).


%% display the results of the calculation
display(_X, _Y, {error, Msg}) ->
    io:format("Error: ~s~n", [Msg]);
display(X, Y, {Div, Mod}) ->
    io:format("X:~w, Y:~w, div:~w, mod:~w~n", [X, Y, Div, Mod]).


%% takes a string, returns either its int value or 'error'
%% prints any error messages
parseInt(IntStr) ->
    case string:to_integer(IntStr) of
        {error, Reason} ->
            io:format("Error parsing ~s: ~w~n", [IntStr, Reason]),
            error;
        {Val, ""} -> Val;
        {Val, Rest} ->
            io:format("What's with the '~s' crap?~n", [Rest]),
            Val
    end.
