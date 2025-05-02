:- dynamic assigned_list/1.

letter_list([
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z'
]).

% Assign boolean values to letters
assign_booleans([], [], []).
assign_booleans(_, [], []).
assign_booleans([Head1|Tail1], [Head2|Tail2], [Head1-Head2|Tail3]) :-
    assign_booleans(Tail1, Tail2, Tail3).

% Begin the stack operations
eval_postfix(Circuit, Result) :-
    eval_postfix(Circuit, [], [Final]),
    Result = Final.

% Base case
eval_postfix([], [Result], [Result]).

% Push variable value onto stack
eval_postfix([Letter|Tail], Stack, Result) :-
    assigned_list(Pairs),
    atom_string(AtomLetter, Letter),  % convert "A" -> 'A' so that circuit operations work
    member(AtomLetter-Val, Pairs),
    eval_postfix(Tail, [Val|Stack], Result).

% OR
eval_postfix(["+"|Tail], [V1,V2|Stack], Result) :-
    atom_string(AtomV1, V1),
    atom_string(AtomV2, V2),
    or_op(AtomV2, AtomV1, R),
    eval_postfix(Tail, [R|Stack], Result).

% AND
eval_postfix(["*"|Tail], [V1,V2|Stack], Result) :-
    atom_string(AtomV1, V1),
    atom_string(AtomV2, V2),
    and_op(AtomV2, AtomV1, R),
    eval_postfix(Tail, [R|Stack], Result).

% NOT
eval_postfix(["-"|Tail], [V|Stack], Result) :-
	atom_string(AtomV, V),
    not_op(AtomV, R),
    eval_postfix(Tail, [R|Stack], Result).

% Circuit operations
or_op('T', _, 'T').
or_op(_, 'T', 'T').
or_op('F', 'F', 'F').

and_op('T', 'T', 'T').
and_op(_, _, 'F').

not_op('T', 'F').
not_op('F', 'T').

% Main entry point
main :-
    % Read Input
    read_line_to_string(user_input, FirstLine),
    read_line_to_string(user_input, SecondLine),
    read_line_to_string(user_input, ThirdLine),
    
    % Convert to string lists
    split_string(FirstLine, " ", "", _), % First line doesn't matter
    split_string(SecondLine, " ", "", SecondLineList),
    split_string(ThirdLine, " ", "", ThirdLineList),
    
    letter_list(Letters),
    
    % Assign each boolean to its corresponding letter of the alphabet for future logic
    assign_booleans(Letters, SecondLineList, AssignedList),
    asserta(assigned_list(AssignedList)),
    
    % Process Circuit
    eval_postfix(ThirdLineList, Result),
    
    % Output result
    write(Result), nl.
    
    
