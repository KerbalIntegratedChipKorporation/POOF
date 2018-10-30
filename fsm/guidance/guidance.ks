// Guidance.ks

Include("statemachine").
Include("list").
Include("navball").

global GuidanceModes is list("LocalVertical", "Prograde", "Retrograde", "Vector", "NullRates", "Heading").

function Guidance_New
{
	// Add parameters here
	// parameter x.
	
	local this is NewStateMachine("Guidance", Guidance_setup@, Guidance_Err@, Guidance_GetData@).
	
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
	
	this:add("dir", up * R(0,0,0)).
	this:add("pitch", 0).
	this:add("yaw", 0).
	this:add("roll", 0).
	this:add("vector", V(0,0,0)).
	
	this:add("locked", false).

	this:add("unlock", Guidance_Unlock@).
	this:add("lock", Guidance_Lock@).
	this:add("setmode", Guidance_SetMode@).
	
	set this["states"][0] to Guidance_LocalVerticalMode@.
	this["states"]:add(Guidance_ProgradeMode@).
	this["states"]:add(Guidance_RetrogradeMode@).
	this["states"]:add(Guidance_VectorMode@).
	this["states"]:add(Guidance_NullRatesMode@).
	this["states"]:add(Guidance_HeadingMode@).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function Guidance_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	lock steering to this["dir"].
	set this["locked"] to true.
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function Guidance_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function Guidance_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	local dir is this["dir"].
	local state is this["state"].
	
	data:add("guidanceMode", state).
	data:add("guidanceModeName", GuidanceModes[state]).
	data:add("steeringLocked", locked).
	data:add("dirPitch", Navball_GetPitchDir(dir)).
	data:add("dirHdg", Navball_GetCompassDir(dir)).
	data:add("dirRoll", Navball_GetRollDir(dir)).
	data:add("dirX", dir:vector:x).
	data:add("dirY", dir:vector:y).
	data:add("dirZ", dir:vector:z).
	data:add("pitchVal", this["pitch"]).
	data:add("yawVal", this["yaw"]).
	data:add("rollVal", this["roll"]).
	data:add("vecX", this["vector"]:x).
	data:add("vecY", this["vector"]:y).
	data:add("vecZ", this["vector"]:z).
	
	return data.
}

////////////////////////////////////////////////////////////////
// STATES //
////////////////////////////////////////////////////////////////

function Guidance_LocalVerticalMode
{
	parameter this.
	
	set this["dir"] to up * R(this["pitch"], this["yaw"], this["roll"]).
	
	return 0.
}

function Guidance_ProgradeMode
{
	local parameter this.
	
	set this["dir"] to prograde * R(this["pitch"], this["yaw"], this["roll"]).
	
	return 0.
}

function Guidance_RetrogradeMode
{
	local parameter this.
	
	set this["dir"] to retrograde * R(this["pitch"], this["yaw"], this["roll"]).
	
	return 0.
}

function Guidance_VectorMode
{
	local parameter this.
	
	set this["dir"] to this["vector"] * R(0,0,this["roll"]).
	return 0.
}

function Guidance_NullRatesMode
{
	local parameter this.
	
	set this["dir"] to ship:facing.
	return 0.
}

function Guidance_HeadingMode
{
	local parameter this.
	
	// Set the direction the heading defined as:
	// COMPASS HEADING = YAW
	// PITCH RELATIVE ABOVE HORIZON = PITCH
	// LEFT-RIGHT (+/-) ROLL = ROLL
	
	set this["dir"] to heading(this["yaw"], this["pitch"]) * R(0,0,this["roll"]).
}

////////////////////////////////////////////////////////////////
// EXTERIOR FUNCTIONS //
////////////////////////////////////////////////////////////////

function Guidance_SetMode
{
	parameter this.
	parameter modeName.
	
	local index is LIST_IndexOf(GuidanceModes, modeName).
	if index >= 0
	{
		set this["state"] to index.
		return 0.
	}
	else
	{
		return -1.
	}
}

function Guidance_Unlock
{
	parameter this.
	
	unlock steering.
	set this["locked"] to false.
}

function Guidance_Lock
{
	parameter this.
	
	lock steering to this["dir"].
	set this["locked"] to true.
}
