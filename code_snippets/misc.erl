-module(misc).

-export([reassign/0]).

reassign() ->
    X = 1,
    X = 2.
