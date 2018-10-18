// statemachine.ks
// Handles finite state machine operations

Include("controller").
Include("list").

// Creates a new finite state machine
function NewStateMachine
{
	parameter controllerType.
	parameter setup.
	parameter err.
	parameter getdata.

	local ctrl is NewController(controllerType, setup, FSM_loop@, err, getdata).
	ctrl:add("state", 0).
	ctrl:add("states", list(FSM_Idle@)).
}

function FSM_loop
{
	parameter this.
	
	local val is this["states"][this["state"]](this).
	if val <> 0
	{
		return this["err"](this).
	}
	else
	{
		return 0.
	}
}

function FSM_Idle
{
	parameter this.
	
	return 0.
}

function SetState
{
	parameter this.
	parameter state.
	
	set stateIndex to LIST_IndexOf(this["states"], state).
	if stateIndex >= 0
	{
		set this["state"] to stateIndex.
		return 0.
	}
	else
	{
		return -1.
	}
}