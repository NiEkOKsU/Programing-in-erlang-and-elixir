%%%-------------------------------------------------------------------
%%% @author proks
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. mar 2023 13:41
%%%-------------------------------------------------------------------
-module(pollution).


%% API
-export([create_monitor/0, add_station/3, add_value/5]).

create_monitor() -> #{}.

name_filter(Name, Keys) ->
  Cmp = fun({{Key, _}, Val}) when Key == Val -> true; (_) -> false end,
  PairsList = [{X, Y} || X <- Keys, Y <- [Name]],
  lists:filter(Cmp, PairsList).

coord_filter(Coords, Keys) ->
  Cmp = fun({{_, Key}, Val}) when Key == Val -> true; (_) -> false end,
  PairsList = [{X, Y} || X <- Keys, Y <- [Coords]],
  lists:filter(Cmp, PairsList).

add_station(Name, {N, W}, M) when is_number(N), is_number(W), is_list(Name) ->
  Keys = maps:keys(M),
  Filtred_name = name_filter(Name, Keys),
  Filtred_coordinates = coord_filter({N, W}, Keys),
  if
    length(Filtred_name) > 0 -> io:format("Stacja o podanej nazwie juz istnieje \n");
    length(Filtred_coordinates) > 0 -> io:format("Stacja o podanych wspolrzednych juz istnieje \n");
    true -> M#{{Name, {N, W}} => []}
  end.

add_value(Name, Data, Type, Value, M) when is_list(Name), is_list(Type), is_number(Value) ->
  [{Key, _} | _] = name_filter(Name, maps:keys(M)),
  #{Key := Val} = M,
  M#{Key := Val ++ [[Data, Type, Value]]};
add_value(Tuple, Data, Type, Value, M) when is_list(Type), is_number(Value) ->
  [{Key, _} | _] = coord_filter(Tuple, maps:keys(M)),
  #{Key := Val} = M,
  M#{Key := Val ++ [[Data, Type, Value]]}.