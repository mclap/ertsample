all: deps compile

deps:
	rebar get-deps

compile:
	rebar compile

doc:
	rebar skip_deps=true doc

clean:
	rebar clean

distclean: clean
	rebar delete-deps

update:
	rebar update-deps

start: all
	deps/yaws/bin/yaws -i -c yaws.conf
