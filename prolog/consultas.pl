:- consult('base_conhecimento.pl').


media_lista(Lista, Media) :-
    sum_list(Lista, Soma),
    length(Lista, Quantidade),
    Quantidade > 0,
    MediaBruta is Soma / Quantidade,
    Media is round(MediaBruta * 100) / 100.


media_pais(Pais, Quantidade, Media) :-
    findall(Nota, cafe(_, Pais, _, _, _, _, _, _, Nota), Notas),
    length(Notas, Quantidade),
    media_lista(Notas, Media).

pais(Pais) :-   
    cafe(_, Pais, _, _, _, _, _, _, _).

ranking_paises(Ranking) :-
    setof(Pais, pais(Pais), Paises),
    findall(Media-Pais-Quantidade,
        (member(Pais, Paises),
         media_pais(Pais, Quantidade, Media),
         Quantidade >= 20),
        Resultados),
    sort(Resultados, Crescente),
    reverse(Crescente, Ranking).


media_processo(Processo, Quantidade, Media) :-
    findall(Nota, cafe(_, _, _, Processo, _, _, _, _, Nota), Notas),
    length(Notas, Quantidade),
    media_lista(Notas, Media).

processo(Processo) :-
    cafe(_, _, _, Processo, _, _, _, _, _).

ranking_processos(Ranking) :-
    setof(Processo, processo(Processo), Processos),
    findall(Media-Processo-Quantidade,
        (member(Processo, Processos),
         media_processo(Processo, Quantidade, Media),
         Quantidade >= 20),
        Resultados),
    sort(Resultados, Crescente),
    reverse(Crescente, Ranking).


media_geral_nota(Media) :-
    findall(Nota, cafe(_, _, _, _, _, _, _, _, Nota), Notas),
    media_lista(Notas, Media).

media_geral_aroma(Media) :-
    findall(Aroma, cafe(_, _, _, _, Aroma, _, _, _, _), Aromas),
    media_lista(Aromas, Media).

media_geral_sabor(Media) :-
    findall(Sabor, cafe(_, _, _, _, _, Sabor, _, _, _), Sabores),
    media_lista(Sabores, Media).

media_geral_acidez(Media) :-
    findall(Acidez, cafe(_, _, _, _, _, _, Acidez, _, _), Acidezes),
    media_lista(Acidezes, Media).

cafes_acima_das_medias(Ranking) :-
    media_geral_nota(MediaNota),
    media_geral_aroma(MediaAroma),
    media_geral_sabor(MediaSabor),
    media_geral_acidez(MediaAcidez),
    findall(Nota-Id-Pais-Variedade-Processo-Aroma-Sabor-Acidez,
        (cafe(Id, Pais, Variedade, Processo, Aroma, Sabor, Acidez, _, Nota),
         Nota > MediaNota,
         Aroma > MediaAroma,
         Sabor > MediaSabor,
         Acidez > MediaAcidez),
        Resultados),
    sort(Resultados, Crescente),
    reverse(Crescente, Ranking).