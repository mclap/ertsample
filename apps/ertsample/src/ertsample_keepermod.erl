-module(ertsample_keepermod).
-author('pavel.plesov@gmail.com').
-export([out/1, out/3]).
-import(lists).
-import(ertsample).

-include("../../../deps/yaws/include/yaws_api.hrl").

box(Str) ->
    {'div',[{class,"box"}],
     {pre,[],Str}}.

short_response(Code, Text) ->
	[{status, Code}, {content, "text/plain", Text}].


short_response(Code, Fmt, Vals) ->
	short_response(Code, lists:flatten(io_lib:format(Fmt, Vals))).

% generic handler
out(A, _Method, "test") ->
    {ehtml,
     [{p,[],
       box(io_lib:format("A#arg.appmoddata = ~p~n"
                         "A#arg.appmod_prepath = ~p~n"
                         "A#arg.querydata = ~p~n"
			 "A = ~p~n",
                         [A#arg.appmoddata,
                          A#arg.appmod_prepath,
                          A#arg.querydata,
			  A]))}]};

%% @doc Entry point for get method
out(_A, 'GET', _) ->
	Chains=ertsample:getall(),
	% convert internal structure to fit json2 serializarion requirements
	JSONChains=lists:map(fun(S) -> {array, element(2,S)} end, Chains),
	io:format("Chains=~p~n", [JSONChains]),
        [{status, 200},
	{content, "application/json",
		json2:encode({array, JSONChains})}];

%% @doc Entry point for get method
out(A, 'PUT', _) ->
	case ertsample:emit(A#arg.clidata) of
		{error,Reason} -> short_response(500, "~p", [Reason]);
		_ -> short_response(200, "OK")
	end;

out(_A, Method, _) ->
	short_response(405, "unsupported method ~p", [Method]).

%% @doc Entry point for http requrests
out(Arg) ->
	% Uri = yaws_api:request_url(Arg),
	out(Arg,
	(Arg#arg.req)#http_request.method,
	Arg#arg.appmoddata).
