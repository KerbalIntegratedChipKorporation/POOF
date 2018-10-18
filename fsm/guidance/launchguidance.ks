// LaunchGuidance.ks

Include("statemachine").

function LaunchGuidance_New
{
	// Add parameters here
	// parameter x.
	parameter platform.
	parameter lv.
	
	local this is NewStateMachine("LaunchGuidance", LaunchGuidance_setup@, LaunchGuidance_Err@, LaunchGuidance_GetData@).
	
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
	
	this:add("platform", platform).
	this:add("lv", lv).
	
	set this["states"][0] to LaunchGuidance_Prelaunch@.
	this["states"]:add(LaunchGuidance_Ignition@).
	this["states"]:add(LaunchGuidance_Guide@).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function LaunchGuidance_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	// Initial guidance should be set to up * R(0,0,180),
	// or directly up with a 180 degree roll angle.
	// This can be achieved by setting the roll angle to 180
	// and setting the guidance mode to Local Vertical
	
	local platform is this["platform"].
	platform["setmode"](platform, "LocalVertical").
	
	set platform["pitch"] to 0.
	set platform["yaw"] to 0.
	set platform["roll"] to 180.
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function LaunchGuidance_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function LaunchGuidance_GetData
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

function LaunchGuidance_Prelaunch
{
	parameter this.
	
	// wait.
	return 0.
}

function LaunchGuidance_Ignition
{
	parameter this.
	
	// Perform ignition sequence.
	local lv is this["lv"].
	lv["ignition"](lv).
	
	set this["state"] to 2.

	return 0.
}

function LaunchGuidance_Guide
{
	parameter this.
	
	if altitude > 2000 { this:clear(). }
	return 0.
}

////////////////////////////////////////////////////////////////
// External Functions //
////////////////////////////////////////////////////////////////

function LaunchGuidance_StartIgnition
{
	parameter this.
	
	set this["state"] to 1.
	return 0.
}
