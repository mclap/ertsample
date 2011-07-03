-module(ertsample_keepermod).
-author('pavel.plesov@gmail.com').
-export([out/1]).

-include("../../../deps/yaws/include/yaws_api.hrl").

box(Str) ->
    {'div',[{class,"box"}],
     {pre,[],Str}}.

out(A, _Uri, ["get"]) ->
    {ehtml,
     [{p,[],
       box(io_lib:format("A#arg.appmoddata = ~p~n"
                         "A#arg.appmod_prepath = ~p~n"
                         "A#arg.querydata = ~p~n",
                         [A#arg.appmoddata,
                          A#arg.appmod_prepath,
                          A#arg.querydata]))}]};

out(A, _Uri, _Path) ->
    {ehtml,
     [{p,[],
       box(io_lib:format("A#arg.appmoddata = ~p~n"
                         "A#arg.appmod_prepath = ~p~n"
                         "A#arg.querydata = ~p~n"
			 "Uri = ~p~n"
			 "Path = ~p~n",
                         [A#arg.appmoddata,
                          A#arg.appmod_prepath,
                          A#arg.querydata,
			  _Uri, _Path]))}]}.

out(Arg) ->
	Uri = yaws_api:request_url(Arg),
	UriPath = Uri#url.path,
	Path = string:tokens(UriPath, "/"),
	out(Arg, Uri, Path).
