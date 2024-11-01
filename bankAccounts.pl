
% Enter the names of your group members below.
% If you only have 2 group members, leave the last space blank
%
%%%%%
%%%%% NAME: Shaghayegh Dehghanisanij
%%%%% NAME: Theresa Killam
%%%%% NAME:
%
% Add the required rules in the corresponding sections.
% If you put the rules in the wrong sections, you will lose marks.
%
% You may add additional comments as you choose but DO NOT MODIFY the comment lines below
%


%%%%% SECTION: database
%%%%% Put statements for account, created, lives, location and gender below

account(1, sherry, cibc, 3200).
account(2, theresa, bank_of_montreal, 4500).
account(3, bob, royal_bank, 6000).
account(4, sarah, cibc, 1500).
account(5, tara, td_bank, 7500).
account(6, james, cibc, 10000).
account(7, niall, bank_of_montreal, 2000).
account(8, zain, royal_bank, 800).
account(9, harry, scotiabank, 5100).
account(10, liam, td_bank, 2750).
account(11, john, td_bank, 1000).



created(1, sherry, cibc, 1, 2022).
created(2, theresa, bank_of_montreal, 5, 2023).
created(3, bob, royal_bank, 3, 2024).
created(4, sarah, cibc, 7, 2021).
created(5, tara, td_bank, 11, 2022).
created(6, james, cibc, 9, 2020).
created(7, niall, bank_of_montreal, 6, 2019).
created(8, zain, royal_bank, 10, 2023).
created(9, harry, scotiabank, 4, 2021).
created(10, liam, td_bank, 8, 2024).
created(11, john, td_bank, 12, 2024).


lives(sherry, toronto).
lives(theresa, scarborough).
lives(bob, richmondHill).
lives(sarah, vancouver).
lives(tara, markham).
lives(james, toronto).
lives(niall, calgary).
lives(zain, mississauga).
lives(harry, montreal).
lives(liam, ottawa).
lives(john, sanFrancisco).



location(toronto, canada).
location(scarborough, canada).
location(richmondHill, canada).
location(vancouver, canada).
location(markham, canada).
location(mississauga, canada).
location(calgary, canada).
location(montreal, canada).
location(ottawa, canada).
location(sanFrancisco, usa).
location(bank_of_montreal, montreal).
location(cibc, toronto).
location(royal_bank, toronto).
location(td_bank, toronto).
location(scotiabank, ottawa).


gender(sherry, woman).
gender(theresa, woman).
gender(bob, man).
gender(sarah, woman).
gender(tara, woman).
gender(james, man).
gender(niall, man).
gender(zain, man).
gender(harry, man).
gender(liam, man).
gender(john, man).







%%%%% SECTION: lexicon
%%%%% Put the rules/statements defining articles, adjectives, proper nouns, common nouns,
%%%%% and prepositions in this section.
%%%%% You should also put your lexicon helpers in this section
%%%%% Your helpers should include at least the following:
%%%%%       bank(X), person(X), man(X), woman(X), city(X), country(X)
%%%%% You may introduce others as you see fit
%%%%% DO NOT INCLUDE ANY statements for account, created, lives, location and gender
%%%%%     in this section




% country(X) it is a location and not a bank
country(X) :- location(_, X), not city(X).

% city(X) it is a location and not a bank
city(X) :- lives(_ , X).


% bank(X) it is a location and not a city
bank(X) :- account(_, _, X, _).
bank(X) :- created(_, _, X, _, _).


man(X) :- gender(_, man).
woman(X) :- gender(_, woman).

person(P) :- account(_, P, _, _).
person(P) :- lives(P, _).
person(P) :- man(X).
person(P) :- woman(X).






article(a).
article(an).
article(the).
article(any).


common_noun(bank, X) :- bank(X).
common_noun(city, X) :- city(X).
common_noun(country, X) :- country(X).
common_noun(man, X) :- man(X).
common_noun(woman, X) :- woman(X).
common_noun(person, X) :- person(X).
common_noun(owner, X) :- person(X).
common_noun(account, X) :- account(_, X, _, _).
common_noun(balance, Balance) :- account(_, _, _, Balance).



proper_noun(X) :- person(X).
proper_noun(X) :- bank(X).
proper_noun(X) :- city(X).
proper_noun(X) :- country(X).
proper_noun(X) :- number(X).




adjective(canadian, X) :- lives(X, City), location(City, canada).
adjective(american, X) :- lives(X, City), location(City, usa).
adjective(british, X) :- lives(X, City), location(City, uk).
adjective(female, X) :- woman(X).
adjective(male, X) :- man(X).
adjective(local, X) :- location(X, canada).
adjective(foreign, X) :- lives(X, City), location(City, Country), not Country = canada.
adjective(small, X) :- account(_, X, _, Balance), Balance < 1000.
adjective(medium, X) :- account(_, X, _, Balance), Balance >= 1000, Balance =< 10000.
adjective(large, X) :- account(_, X, _, Balance), Balance > 10000.
adjective(old, X) :- created(_, X, _, _, Year), Year < 2024.
adjective(new, X) :- created(_, X, _, _, 2024).
recent(X) :- created(_, X, _, _, 2024).





% Cities in countries
preposition(in, City, Country) :- city(City), location(City, Country).

% Banks in cities
preposition(in, Bank, City) :- bank(Bank), location(Bank, City).

% Accounts in banks
preposition(in, Account, Bank) :- account(_, _, Bank, _), account(_, Account, Bank, _).
















%%%%% SECTION: parser
%%%%% For testing your lexicon for question 3, we will use the default parser initially given to you.
%%%%% ALL QUERIES IN QUESTION 3 and 4 SHOULD WORK WHEN USING THE DEFAULT PARSER
%%%%% For testing your answers for question 5, we will use your parser below
%%%%% You may include helper predicates for Question 5 here, but they
%%%%% should not be needed for Question 3
%%%%% DO NOT INCLUDE ANY statements for account, created, lives, location and gender
%%%%%     in this section

what(Words, Ref) :- np(Words, Ref).

/* Noun phrase can be a proper name or can start with an article */

np([Name],Name) :- proper_noun(Name).
np([Art|Rest], What) :- article(Art), np2(Rest, What).


/* If a noun phrase starts with an article, then it must be followed
   by another noun phrase that starts either with an adjective
   or with a common noun. */

np2([Adj|Rest],What) :- adjective(Adj,What), np2(Rest, What).
np2([Noun|Rest], What) :- common_noun(Noun, What), mods(Rest,What).

/* Modifier(s) provide an additional specific info about nouns.
   Modifier can be a prepositional phrase followed by none, one or more
   additional modifiers.  */

mods([], _).
mods(Words, What) :-
    appendLists(Start, End, Words),
    prepPhrase(Start, What),    mods(End, What).

prepPhrase([Prep | Rest], What) :-
    preposition(Prep, What, Ref), np(Rest, Ref).

appendLists([], L, L).
appendLists([H | L1], L2, [H | L3]) :-  appendLists(L1, L2, L3).
