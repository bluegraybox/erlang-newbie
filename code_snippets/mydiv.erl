#!/usr/local/bin/escript
%%! -smp enable -sname mydiv

-mode(compile).  % for better performance

f(_X, 0) -> {error, "Divide by zero, dumbass."};
f(X, Y) -> {X div Y, X rem Y}.

main([Xstr, Ystr]) ->
    ParseY = fun (X) ->
        BothOk = fun (Y) ->
            display(X, Y)
        end,
        parseInt(Ystr, BothOk)
    end,
    parseInt(Xstr, ParseY).

display(X, Y) ->
    case f(X, Y) of
        {error, Msg} -> io:format("Error: ~s~n", [Msg]);
        {Div, Mod} -> io:format("X:~w, Y:~w, div:~w, mod:~w~n", [X, Y, Div, Mod])
    end.

parseInt(IntStr, Success) ->
    case string:to_integer(IntStr) of
        {error, Reason} ->
            io:format("Error parsing ~s: ~w~n", [IntStr, Reason]);
        {Val, ""} ->
            Success(Val);
        {Val, Rest} ->
            io:format("What's with the '~s' crap?~n", [Rest]),
            Success(Val)
    end.
