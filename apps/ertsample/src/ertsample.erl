%%% @author Pavel Plesov <pavel.plesov@gmail.com>
%%% @doc Yaws applications handler.

-module(ertsample).
-author('pavel.plesov@gmail.com').

-export([start/0]).
-export([emit/1, getall/0, clearall/0]).

start() ->
	application:start(ertsample).

getall() ->
	gen_event:call(ertsample_keeper, ertsample_keeper, getall).
emit(Value) ->
	gen_event:call(ertsample_keeper, ertsample_keeper, {emit, Value}).
clearall() ->
	gen_event:call(ertsample_keeper, ertsample_keeper, clearall).
