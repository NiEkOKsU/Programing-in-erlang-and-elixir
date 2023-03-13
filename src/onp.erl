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
  case El of
    error -> fromString([H | T], 0);
    _ ->[El] ++ fromString(T)
    end.

fromString([H | T], 0) ->
  {El, _} = string:to_integer(H),
  case El of
    error -> fromString([H | T], 1);
    _ ->[El] ++ fromString(T)
  end;
fromString([H | T], 1) ->
  [H] ++ fromString(T).

onp(Tab) -> onp([], fromString(string:tokens(Tab, "x "))).

onp([Value | []], []) -> Value;
onp(Stack, [H | T]) when is_integer(H); is_float(H) -> onp([H] ++ Stack, T);
onp(Stack, [H | T]) when length(Stack) >= 1, H == "sqrt" ->
  [El1 | Rest] = Stack,
  onp( [math:sqrt(El1) | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 2, H == "pow" ->
  [El1, El2 | Rest] = Stack,
  onp( [math:pow(El1, El2) | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 1, H == "sin" ->
  [El1 | Rest] = Stack,
  onp( [math:sin(El1) | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 1, H == "cos" ->
  [El1 | Rest] = Stack,
  onp( [math:cos(El1) | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 1, H == "tg" ->
  [El1 | Rest] = Stack,
  onp( [math:tan(El1) | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 1, H == "ctg" ->
  [El1 | Rest] = Stack,
  onp( [1/math:tan(El1) | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 2, H == "+" ->
  [El1, El2 | Rest] = Stack,
  onp( [El1 + El2 | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 2, H == "-" ->
  [El1, El2 | Rest] = Stack,
  onp( [El1 - El2 | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 2, H == "*" ->
  [El1, El2 | Rest] = Stack,
  onp( [El1 * El2 | Rest], T);
onp(Stack, [H | T]) when length(Stack) >= 2, H == "/" ->
  [El1, El2 | Rest] = Stack,
  onp( [El1 / El2 | Rest], T);
onp(Stack, [_ | T]) when length(Stack) >= 2 ->
  onp(Stack, T).
