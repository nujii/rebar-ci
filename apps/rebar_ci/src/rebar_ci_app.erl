-module(rebar_ci_app).

-behaviour(application).

-include ("rebar_ci.hrl").

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    case rebar_ci_sup:start_link() of
        {ok, Pid} ->
            ok = riak_core:register([{vnode_module, rebar_ci_vnode}]),
            ok = riak_core_ring_events:add_guarded_handler(rebar_ci_ring_event_handler, []),
            ok = riak_core_node_watcher_events:add_guarded_handler(rebar_ci_node_event_handler, []),
            ok = riak_core_node_watcher:service_up(rebar_ci, self()),

            DispatchFile = filename:join([code:priv_dir(rebar_ci), "dispatch.econf"]),
            {ok, Dispatch} = file:consult(DispatchFile),
            ok = add_routes(Dispatch),

            {ok, Pid};
        {error, Reason} ->
            {error, Reason}
    end.

stop(_State) ->
    ok.

add_routes([]) ->
    ok;
add_routes([Route|OtherRoutes]) ->
    ok = webmachine_router:add_route(Route),
    add_routes(OtherRoutes).