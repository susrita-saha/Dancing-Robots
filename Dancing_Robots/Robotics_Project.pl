
:-dynamic handler1/3.
%:-dynamic origin_port/2.
:-dynamic send_method/4.
:-dynamic handler_initialize/3.
:-dynamic handler_forward/3.
:-dynamic handler_backward/3.
:-dynamic handler_backward_left/3.
:-dynamic handler_backward_right/3.
:-dynamic handler_forward_left/3.
:-dynamic handler_forward_right/3.

% start method takes Port(on which we have to start tartarus platform ) and Token for set_token method
start(Port, Token):-
	%consult("C:\\Tartarus\\platform.pl"),
	start_tartarus(localhost, Port),
	set_token(Token).

%closes tartarus platform
close:- close_tartarus.

% handler for initializing ultrasonic sensor. 
handler_initialize(guid,(_,_),main):-
	init_all.

%handler for forward movement
handler_forward(guid,(_,_),main):-
	forward(50).

%handler for backward movement and rotation of ultrasonic sensor.
handler_backward(guid,(_,_),main):-
	rotate_nxt('bond','C',180,'C'),
	backward(50),
	rotate_nxt('bond','C',180,'A').

%handler for backward_left movement and rotation of ultrasonic sensor.
handler_backward_left(guid,(_,_),main):-
	rotate_nxt('bond','C',180,'C'),
	backward_left(50),
	rotate_nxt('bond','C',180,'A').

%handler for backward_right movement and rotation of ultrasonic sensor.
handler_backward_right(guid,(_,_),main):-
	rotate_nxt('bond','C',180,'C'),
	backward_right(50),
	rotate_nxt('bond','C',180,'A').

%handler for forward_left movement
handler_forward_left(guid,(_,_),main):-
	forward_left(50).

%handler for forward_right movement
handler_forward_right(guid,(_,_),main):-
	forward_right(50).

%testing whether connection is made .
sing:-
	beep_nxt('bond',2),
	beep_nxt('bond',3),
	beep_nxt('bond',1),
	beep_nxt('bond',2),
	beep_nxt('bond',3),
	beep_nxt('bond',3),
	beep_nxt('bond',3),
	beep_nxt('bond',1).

%function for executing combination of moves.
combo(Port2,Token2,Port3,Token3):-
	send_method(Port2,Token2,Port3,Token3,handler_initialize),

	one_move(Port2,Token2,Port3,Token3),

	send_to_one(Port2,Token2,handler_forward),
	send_to_one(Port3,Token3,handler_forward),

	%sleep(7),

	one_move(Port2,Token2,Port3,Token3).
  
%move for demo.
one_move(Port2,Token2,Port3,Token3):-
	
	send_method(Port2,Token2,Port3,Token3,handler_forward),
	sleep(10),
	send_method(Port2,Token2,Port3,Token3,handler_backward),
	sleep(10),

	send_method(Port2,Token2,Port3,Token3,handler_forward_right),
	sleep(10),
	send_method(Port2,Token2,Port3,Token3,handler_backward_right),
	sleep(10),
	
	send_method(Port2,Token2,Port3,Token3,handler_forward_left),
	sleep(10),
	send_method(Port2,Token2,Port3,Token3,handler_backward_left),
	sleep(10).


%creates and clones agent on two Ports.
send_method(Port2,Token2,Port3,Token3,HandlerCustom):-
	create_mobile_agent(agent1,(localhost,50001),HandlerCustom),
	add_token(agent1,[1111,Token2,Token3]),
	clone_agent(agent1,(localhost,Port2),Agent2),
	clone_agent(agent1,(localhost,Port3),Agent3),
	execute_agent(agent1,(localhost,50001),HandlerCustom).

%creates and clones agent on a Port.
send_to_one(Port2,Token2,HandlerCustom):-
	create_mobile_agent(agent1,(localhost,50001),HandlerCustom),
	add_token(agent1,[Token2]),
	%clone_agent(agent1,(localhost,Port2),Agent2).
	move_agent(agent1,(localhost,Port2)).

%initializes ultrasonic sensor.
init_all:-
	init_ultrasonic_nxt('bond',2).


% forward move
forward(0):- stop_nxt('bond','A','B').
forward(N):-
	writeln('forward'),
	read_ultrasonic_nxt('bond',2,U),
	(U<25 -> 
		stop_nxt('bond','A','B');
		move_forward_nxt('bond','A','B',100)
	),
	N1 is N-1,
	forward(N1).


% backward move
backward(0):- stop_nxt('bond','A','B').
backward(N):-
	writeln('backward'),
	read_ultrasonic_nxt('bond',2,U),
	(U<25 -> 
		stop_nxt('bond','A','B');
		move_backward_nxt('bond','A','B',100)
	),
	N1 is N-1,
	backward(N1).


% forward left move
forward_left(0):- stop_nxt('bond','A','B').
forward_left(N):-
	writeln('forward left'),
	read_ultrasonic_nxt('bond',2,U),
	(U<25 -> 
		stop_nxt('bond','A','B');
		move_forward_nxt('bond','A',50),
		move_forward_nxt('bond','B',100)
	),
	N1 is N-1,
	forward_left(N1).


% forward right move
forward_right(0):- stop_nxt('bond','A','B').
forward_right(N):-
	writeln('forward right'),
	read_ultrasonic_nxt('bond',2,U),
	(U<25 -> 
		stop_nxt('bond','A','B');
		move_forward_nxt('bond','A',100),
		move_forward_nxt('bond','B',50)
	),
	N1 is N-1,
	forward_right(N1).

% backward left move
backward_left(0):- stop_nxt('bond','A','B').
backward_left(N):-
	writeln('backward left'),
	read_ultrasonic_nxt('bond',2,U),
	(U<25 -> 
		stop_nxt('bond','A','B');
		move_backward_nxt('bond','A',50),
		move_backward_nxt('bond','B',100)
	),
	N1 is N-1,
	backward_left(N1).


% backward right move
backward_right(0):- stop_nxt('bond','A','B').
backward_right(N):-
	writeln('backward right'),
	read_ultrasonic_nxt('bond',2,U),
	(U<25 -> 
		stop_nxt('bond','A','B');
		move_backward_nxt('bond','A',100),
		move_backward_nxt('bond','B',50)
	),
	N1 is N-1,
	backward_right(N1).


