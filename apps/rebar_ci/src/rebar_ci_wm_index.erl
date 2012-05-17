-module(rebar_ci_wm_index).
-export([
         init/1,
         is_authorized/2,
         allowed_methods/2,
         content_types_provided/2,
         to_json/2,
         to_erlang/2
        ]).

-include_lib("webmachine/include/webmachine.hrl").

init(_Props) ->
    {ok, none}.

is_authorized(_RD, _Ctx) ->
    {true, _RD, _Ctx}.

allowed_methods(_RD, _Ctx) ->
    {['GET'], _RD, _Ctx}.

content_types_provided(_RD, _Ctx) ->
    {[
        {"application/json", to_json},
        {"application/x-erlang-binary", to_erlang}
    ], _RD, _Ctx}.

to_json(_RD, _Ctx) ->
    Pong = process_get(_RD, _Ctx),
    Message = {struct, [{ping, Pong}]},
    JSON = mochijson2:encode(Message),
    {JSON, _RD, _Ctx}.

to_erlang(_RD, _Ctx) ->
    Pong = process_get(_RD, _Ctx),
    IoList = io_lib:format("~p",[{ping, Pong}]),
    {erlang:list_to_binary(IoList), _RD, _Ctx}.

process_get(_RD, _Ctx) ->
    {pong, Pong} = rebar_ci:ping(),
    Pong.