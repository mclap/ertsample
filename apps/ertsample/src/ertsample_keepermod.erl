-module(ertsample_keepermod).
-author('pavel.plesov@gmail.com').
-export([out/1, out/2]).
-import(lists).
-import(ertsample_keeper).

-include("../../../deps/yaws/include/yaws_api.hrl").

box(Str) ->
    {'div',[{class,"box"}],
     {pre,[],Str}}.

out(_A, "get") ->
	Chains=ertsample_keeper:getall(),
	JSONChains=lists:map(fun(S) -> {array, element(2,S)} end, Chains),
	io:format("Chains=~p~n", [JSONChains]),
        [{status, 200},
	{content, "application/json",
		json2:encode({array, JSONChains})}];

out(A, _Path) ->
    {ehtml,
     [{p,[],
       box(io_lib:format("A#arg.appmoddata = ~p~n"
                         "A#arg.appmod_prepath = ~p~n"
                         "A#arg.querydata = ~p~n"
			 "Path = ~p~n",
                         [A#arg.appmoddata,
                          A#arg.appmod_prepath,
                          A#arg.querydata,
			  _Path]))}]}.

out(Arg) ->
	% Uri = yaws_api:request_url(Arg),
	out(Arg, Arg#arg.appmoddata).
