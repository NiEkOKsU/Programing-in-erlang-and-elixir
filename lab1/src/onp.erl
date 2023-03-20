%%%-------------------------------------------------------------------
%%% @author pc
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. lut 2023 19:58
%%%-------------------------------------------------------------------
-module(onp).


%% API
-export([onp/1]).

fromString([H | []]) -> [H];
fromString([H | T]) ->
  {El, _} = string:to_float(H),
  {El2, _} = string:to_integer(H),
  if
    El == error, El2 == error -> [H] ++ fromString(T);
    El2 == error ->[El] ++ fromString(T);
    true -> [El2] ++ fromString(T)
    end.

onp(Tab) -> onp([], fromString(string:tokens(Tab, "x "))).

onp([Value | []], []) -> Value;
onp(Stack, [H | T]) when is_integer(H); is_float(H) -> onp([H] ++ Stack, T);
onp([El1 | Rest], [H | T]) when H == "sqrt" ->
  onp( [math:sqrt(El1) | Rest], T);
onp([El1, El2 | Rest], [H | T]) when H == "pow" ->
  onp( [math:pow(El2, El1) | Rest], T);
onp([El1 | Rest], [H | T]) when H == "sin" ->
  onp( [math:sin(El1) | Rest], T);
onp([El1 | Rest], [H | T]) when H == "cos" ->
  onp( [math:cos(El1) | Rest], T);
onp([El1 | Rest], [H | T]) when H == "tg" ->
  onp( [math:tan(El1) | Rest], T);
onp([El1 | Rest], [H | T]) when H == "ctg" ->
  onp( [1/math:tan(El1) | Rest], T);
onp([El1, El2 | Rest], [H | T]) when H == "+" ->
  onp( [El2 + El1 | Rest], T);
onp([El1, El2 | Rest], [H | T]) when H == "-" ->
  onp( [El2 - El1 | Rest], T);
onp([El1, El2 | Rest], [H | T]) when H == "*" ->
  onp( [El2 * El1 | Rest], T);
onp([El1, El2 | Rest], [H | T]) when H == "/" ->
  onp( [El2 / El1 | Rest], T);
onp(Stack, [_ | T]) when length(Stack) >= 2 ->
  onp(Stack, T).
