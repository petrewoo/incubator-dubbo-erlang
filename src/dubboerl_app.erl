%%------------------------------------------------------------------------------
%% Licensed to the Apache Software Foundation (ASF) under one or more
%% contributor license agreements.  See the NOTICE file distributed with
%% this work for additional information regarding copyright ownership.
%% The ASF licenses this file to You under the Apache License, Version 2.0
%% (the "License"); you may not use this file except in compliance with
%% the License.  You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%------------------------------------------------------------------------------
-module(dubboerl_app).

-behaviour(application).

-include("dubboerl.hrl").
%% Application callbacks
-export([start/2, stop/1, env_init/0]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    io:format("[START] dubbo framework server start~n"),
%%    env_init(),
    dubboerl_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
env_init() ->
    ets:new(?PROVIDER_IMPL_TABLE, [public, named_table]),
    dubbo_traffic_control:init(),
    type_register:init(),
    register_type_list().
%%    type_decoding:init().


register_type_list() ->
    List = java_type_defined:get_list(),
    lists:map(
        fun({NativeType, ForeignType, Fields}) ->
            dubbo_type_transfer:pre_process_typedef(NativeType, ForeignType, Fields)
        end, List),
    ok.