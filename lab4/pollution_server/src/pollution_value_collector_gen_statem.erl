%%%-------------------------------------------------------------------
%%% @author proks
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. maj 2023 15:50
%%%-------------------------------------------------------------------
-module(pollution_value_collector_gen_statem).
-author("proks").

-behaviour(gen_statem).

-export([init/1, callback_mode/0]).
-export([start_link/0, stop/0, terminate/3]).
-export([set_station/1, add_value/3, store_data/0]).
-export([station/3, values/3]).

-define(SERVER, ?MODULE).

start_link() -> gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).
stop() -> gen_statem:stop(?MODULE).
terminate(_Reason, _StateName, _StateData) -> ok.

init(_Args) -> {ok, station, []}.
callback_mode() -> state_functions.

%% public API
set_station(Id) -> gen_statem:cast(?MODULE, {set_station, Id}).
add_value(Time, Type, Value) -> gen_statem:cast(?MODULE, {add_value, Time, Type, Value}).
store_data() -> gen_statem:cast(?MODULE, {store_data}).

station(_Event, {set_station, Id}, _State) ->
  {next_state, values, #{station => Id, measurements => []}}.

values(_Event, {add_value, Datetime, Type, Value}, State) ->
  Measurements = maps:get(measurements, State),
  NewState = State#{measurements := [{Datetime, Type, Value} | Measurements]},
  {keep_state, NewState};

values(_Event, {store_data}, State) ->
  flush_data(State),
  {keep_state, State#{measurements => []}}.

flush_data(#{station := _Station, measurements := []}) -> ok;
flush_data(#{station := Station, measurements := [{Datetime, Type, Value} | Measurements]}) ->
  pollution_gen_server:add_value(Station, Datetime, Type, Value),
  flush_data(#{station => Station, measurements => Measurements}).

