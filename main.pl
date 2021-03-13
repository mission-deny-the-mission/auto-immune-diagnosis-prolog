:- retractall(symptom(X, Y)).
:- retractall(explanation(X, Y)).
:- retractall(disease(X)).

:- retractall(ask_symptoms2).
:- retractall(match_disease(X)).
:- retractall(match_disease(X, Y)).
:- retractall(print_array(X)).
:- retractall(main).

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

match_disease(Disease) :-
    bagof(Patient_symptom, patients_symptoms(Patient_symptom), [Head | Tail]),
    symptom(Disease, Head),
    match_disease(Disease, Tail).

match_disease(Disease, []).
match_disease(Disease, [Head | Tail]) :-
    Head \= [],
    symptom(Disease, Head),
    match_disease(Disease, Tail).

print_array([]).
print_array([Head | Tail]) :-
    Head \= [],
    write_ln(Head),
    print_array(Tail).


main :-
    retractall(patients_symptoms(X)),
    ask_symptoms2,
    bagof(Disease, match_disease(Disease), Diseases),
    (Diseases \= [] ->
        write_ln('Diseases matching all symptoms:'),
		print_array(Diseases);
		write_ln('Could not find a disease that matches all of the symptoms.')
	).

:- main.