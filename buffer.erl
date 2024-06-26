-module(buffer).
-export([start/0]).

start() ->
    %% Mensagem de console para inicialização do buffer
    io:format("[Buffer] - Buffer Iniciado~n"),
    buffer([]).

buffer(Products) ->
    %% Mensagem de console com o conteúdo da lista
    io:format("[Buffer] - Lista atual: ~p~n", [Products]),

    %% Espera por mensagens de produção e consumo
    receive
        %% Adiciona itens ao buffer quando recebe mensagens do produtor
        {produtor, Item} ->
            NewProducts = [Item | Products],
            buffer(NewProducts);

        %% Retorna itens (ou vazio) para consumidores quando recebe solicitação
        {consumidor, PidConsumidor} ->
            case Products of
                [] ->
                    PidConsumidor ! {empty},
                    buffer(Products);
                [Product | AllProducts] ->
                    PidConsumidor ! {consumidor, Product},
                    buffer(AllProducts)
            end
    end.
