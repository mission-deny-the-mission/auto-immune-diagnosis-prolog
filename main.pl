:- multifile symptom/2.
:- multifile explanation/2.
:- multifile disease/1.

:- consult('diseases/CGD.pl').
:- consult('diseases/Grave\'s disease.pl').
:- consult('diseases/HIV.pl').
:- consult('diseases/lupus.pl').
:- consult('diseases/SCID.pl').
:- consult('diseases/Type 1 Diabetes.pl').
:- consult('diseases/vasculitis.pl').
%consult('diseases/.pl').

:- dynamic patients_symptoms/1.

ask_symptoms2 :-
    write_ln('Patient\'s symptom'),
    read(Symptom),
    (symptom(_, Symptom) ->
        assert(patients_symptoms(Symptom)),
        ask_symptoms2;
        (Symptom = 'stop' ->
            true
            ;
            write_ln('That is not a valid symptom. Please try again.'),
            ask_symptoms2
        )
    ).

:- dynamic possible_diseases/1.

find_diseases(Symptom) :-
    symptom(Disease, Symptom),
    assert(matching_disease(Disease, Symptom)),
    (possible_diseases(Disease) ->
        true;
        assert(possible_diseases(Disease))
    ).


match_symptoms :-
    bagof(Symptom, patients_symptoms(Symptom), Symptoms),
    match_symptoms(Symptoms).

match_symptoms([]).
match_symptoms([Head | Tail]) :-
    Head \= [],
    find_diseases(Head),
    match_symptoms(Tail).


:- dynamic fully_matching_diseases/1.

find_full_matches :-
    bagof(Disease, possible_diseases(Disease), Diseases),
    find_full_matches(Diseases).

find_full_matches([]).
find_full_matches([Disease | Rest]) :-
    Disease \= [],
    bagof(Symptom, patients_symptoms(Symptom), Symptoms),
    find_full_matches(Rest),
    (find_full_matches(Disease, Symptoms) ->
        assert(fully_matching_diseases(Disease));
        true
    ).

find_full_matches(Disease, []).
find_full_matches(Disease, [Symptom | Rest]) :-
    Symptom \= [],
    (symptom(Disease, Symptom) ->
        find_full_matches(Disease, Rest);
        false
    ).

print_full_matches :-
    bagof(Disease, fully_matching_diseases(Disease), Diseases),
    print_full_matches(Diseases).

print_full_matches([]).
print_full_matches([Head | Tail]) :-
    Head \= [],
    write_ln(Head),
    print_full_matches(Tail).


main :-
    ask_symptoms2,
    match_symptoms,
    find_full_matches,
    print_full_matches.

% ask_symptoms2.
% match_symptoms.
% find_full_matches.
% write_ln('Fully mathcing diseases:').
% print_full_matches.