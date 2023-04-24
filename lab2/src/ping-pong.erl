%%%-------------------------------------------------------------------
%%% @author proks
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. mar 2023 15:20
%%%-------------------------------------------------------------------
-module('ping-pong').

%% API
-export([start/0, stop/0, play/1, ping/0, pong/0]).

start() ->
  Pid1 = spawn(?MODULE, ping, []),
  Pid2 = spawn(?MODULE, pong, []),
  register(ping, Pid1),
  register(pong, Pid2).

stop() ->
  ping ! stop,
  pong ! stop.

play(N) when is_integer(N) ->
  ping ! N.

ping() ->
  receive
    0 -> ping();
    stop -> ok;
    N -> pong ! N - 1, timer:sleep(1000), io:format("ping ~w ~n", [N]), ping()
  end.

pong() ->
  receive
    0 -> pong();
    stop -> ok;
    N -> ping ! N - 1, timer:sleep(1000),io:format("pong ~w ~n", [N]) ,pong()
  end.
