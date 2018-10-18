// fsm.ks

Include("statemachine").

function fsm_New
{
	// Add parameters here
	// parameter x.
	
	local this is NewStateMachine("fsm", fsm_setup@, fsm_Err@, fsm_GetData@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	// Add states to the state list.
	// this["states"]:add(MyState@).
	
	// REMEMBER: State 0 is by default set to the idle state.
	// State 0 should always be your initial state.
	// You should change that here by using:
	// set this["states"][0] to MyState@.
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function fsm_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function fsm_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function fsm_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}

////////////////////////////////////////////////////////////////
// STATES //
////////////////////////////////////////////////////////////////

function fsm_MyState
{
	parameter this.
	
	// DO STUFF HERE
	// Don't forget to add this to the state list.
	
	// Change state using:
	// SetState(this, fsm_MyOtherState@).
	// or
	// set this["state"] to 3.
	
	// SetState will return -1 if the value provided is not in states.
	
	return 0.
}
