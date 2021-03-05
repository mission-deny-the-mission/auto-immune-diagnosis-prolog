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

:- dynamic patientssymptoms/1.

ask_symptoms2 :-
    write_ln('Patient\'s symptom'),
    read(Symptom),
    (symptom(_, Symptom) ->
        assert(patientssymptoms(Symptom)),
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
    bagof(Symptom, patientssymptoms(Symptom), Symptoms),
    match_symptoms(Symptoms).
match_symptoms([]).
match_symptoms([Head | Tail]) :-
    Head \= [],
    find_diseases(Head),
    match_symptoms(Tail).