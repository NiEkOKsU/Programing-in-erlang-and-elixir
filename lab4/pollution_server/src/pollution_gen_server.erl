-module(pollution_gen_server).

-behaviour(gen_server).

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).
-export([add_station/2,
  add_value/4,
  remove_value/3,
  get_one_value/3,
  get_daily_mean/2,
  get_station_mean/2,
  get_daily_average_data_count/0,
  get_info/0,
  crash/0,
  stop/0]).
-define(SERVER, ?MODULE).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, pollution:create_monitor(), []).

init(Monitor) ->
  {ok, Monitor}.

add_station(Name, Coord) ->
  gen_server:cast(pollution_gen_server, {add_station, Name, Coord}).

add_value(Id, Datetime, Type, Value) ->
  gen_server:cast(pollution_gen_server, {add_value, Id, Datetime, Type, Value}).

remove_value(Id, Datetime, Type) ->
  gen_server:cast(pollution_gen_server, {remove_value, Id, Datetime, Type}).

get_one_value(Id, Datetime, Type) ->
  gen_server:call(pollution_gen_server, {get_one_value,Id, Datetime, Type}).

get_daily_mean(Date, Type) ->
  gen_server:call(pollution_gen_server, {get_daily_mean,Date, Type}).

get_station_mean(Id, Type) ->
  gen_server:call(pollution_gen_server, {get_station_mean, Id, Type}).

get_daily_average_data_count() ->
  gen_server:call(pollution_gen_server, {get_daily_average_data_count}).

get_info() ->
  gen_server:call(pollution_gen_server, {get_info}).

crash() ->
  gen_server:cast(pollution_gen_server, crash).

stop() ->
  gen_server:cast(pollution_gen_server, stop).

handle_cast({add_station, Name, Coord}, Monitor) ->
  {noreply, pollution:add_station(Name, Coord, Monitor)};

handle_cast({add_value, Id, Datetime, Type, Value},Monitor) ->
  {noreply, pollution:add_value(Id, Datetime, Type, Value, Monitor)};

handle_cast({remove_value, Id, Datetime, Type}, Monitor) ->
  {noreply, pollution:remove_value(Id, Datetime, Type, Monitor)};

handle_cast(stop, Monitor) ->
  {stop, normal, Monitor};

handle_cast(crash, Monitor) ->
  1/0,
  {noreply, Monitor}.

handle_call({get_one_value, Id, Datetime, Type}, _, Monitor) ->
  {reply, pollution:get_one_value(Id, Datetime, Type, Monitor), Monitor};

handle_call({get_daily_mean, Date, Type}, _, Monitor) ->
  {reply, pollution:get_daily_mean(Date, Type, Monitor), Monitor};

handle_call({get_station_mean, Id, Type}, _, Monitor) ->
  {reply, pollution:get_station_mean(Id, Type, Monitor), Monitor};

handle_call({get_daily_average_data_count}, _, Monitor) ->
  {reply, pollution:get_daily_average_data_count(Monitor), Monitor};

handle_call({get_info}, _, Monitor) -> {reply, Monitor, Monitor}.

terminate(Reason, _Value) ->
  io:format("Server stopped.~n"),
  Reason.


%%%===================================================================
%%% Internal functions
%%%===================================================================
