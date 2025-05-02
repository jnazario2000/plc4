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

% Evaluate a postfix boolean expression with variable values.
eval_postfix(ExpressionList, VarBindings, Result) :-
    eval_postfix(ExpressionList, VarBindings, [], [Final]),
    Result = Final.

% Base case: stack has one value left (the result)
eval_postfix([], _, [Result], [Result]).

% Push variable value onto stack
eval_postfix([Token|Rest], Vars, Stack, Result) :-
    member(Token-Val, Vars),
    eval_postfix(Rest, Vars, [Val|Stack], Result).

% Handle binary OR
eval_postfix(['+'|Rest], Vars, [V1,V2|Stack], Result) :-
    or_op(V2, V1, R),
    eval_postfix(Rest, Vars, [R|Stack], Result).

% Handle binary AND
eval_postfix(['*'|Rest], Vars, [V1,V2|Stack], Result) :-
    and_op(V2, V1, R),
    eval_postfix(Rest, Vars, [R|Stack], Result).

% Handle unary NOT
eval_postfix(['-'|Rest], Vars, [V|Stack], Result) :-
    not_op(V, R),
    eval_postfix(Rest, Vars, [R|Stack], Result).

% Define operators
is_operator('+').
is_operator('*').
is_operator('-').

% Boolean logic operations
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
    split_string(FirstLine, " ", "", _), % First line doesnt matter
    split_string(SecondLine, " ", "", SecondLineList),
    split_string(ThirdLine, " ", "", ThirdLineList),
    
    letter_list(Letters),
    
    % Assign each boolean to its corresponding letter of the alphabet for future use
    assign_booleans(Letters, SecondLineList, AssignedList),
    asserta(assigned_list(AssignedList)),
    
    % Process Gates
    eval_postfix(ThirdLineList, AssignedList, Result),
    
    % Output result
    write(Result), nl.
