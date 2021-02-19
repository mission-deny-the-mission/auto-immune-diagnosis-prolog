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

conc([], L, L).
conc([X | L1], L2, [X | L3]) :-
    conc(L1, L2, L3).

ask_symptom(Symptom) :-
    write_ln('Symptom'),
    read(Symptom).

identify(Diseases) :-
    ask_symptom(Symptom),
    bagof(Disease, symptom(Disease, Symptom), Diseases).

Diagnose()
Diagnose([Symptom], Diseases) :-
    bagof(Disease, symptom(Disease, Symptom), Diseases).
    
Diagnose([Symptom | RestOfSymptoms], Diseases) :-
    bagof(Disease, and(symptom(Disease, Symptom), member(Disease, Diseases)), NewDiseases),
    diagnose(NewDiseases).
    

ask_symptoms(SymptomsSoFar) :-
    ask_symptom(Symptom),
    symptom(_, Symptom) ->
        conc(Symptom, SymptomsSoFar, X), Diagnose(SymptomsSoFar);
        ask_symptoms([Symptom | SymptomsSoFar]).