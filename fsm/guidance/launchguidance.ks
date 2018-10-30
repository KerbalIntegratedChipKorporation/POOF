// LaunchGuidance.ks

Include("statemachine").

function LaunchGuidance_New
{
	// Add parameters here
	// parameter x.
	parameter platform.
	parameter lv.
	parameter ap.
	parameter hdg.
	parameter rollRate.
	
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
	this:add("ap", ap).
	this:add("tgtHdg", hdg).
	this:add("hdg", 0).
	this:add("rate", rollRate).
	this:add("time", time:seconds).
	
	set this["states"][0] to LaunchGuidance_Prelaunch@.
	this["states"]:add(LaunchGuidance_Ignition@).
	this["states"]:add(LaunchGuidance_Guide@).
	this["states"]:add(LaunchGuidance_Roll@).
	this["states"]:add(LaunchGuidance_Pitch@).
	
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

// State 0
function LaunchGuidance_Prelaunch
{
	parameter this.
	
	// wait.
	return 0.
}

// State 1
function LaunchGuidance_Ignition
{
	parameter this.
	
	// Perform ignition sequence.
	local lv is this["lv"].
	lv["ignition"](lv).
	
	set this["state"] to 2.

	return 0.
}

// State 2
function LaunchGuidance_Guide
{
	parameter this.
	
	if altitude > 2000 { set this["state"] to 3. }
	return 0.
}

// State 3
function LaunchGuidance_Roll
{
	parameter this.
	
	if altitude > 3500 { set this["state"] to 4. return 0.}
	
	local deltaTime is time:secnds - this["time"}.
	local deltaRoll is this["rate"] * deltaTime.
	
	set this["hdg"] to this["hdg"] + deltaRoll.
	local diff is abs(this["hdg"] - this["tgtHdg"]).
	if diff < abs(deltaRoll * 2)
	{
		set this["hdg"] to this["tgtHdg"].
	}
	set this["platform"]["roll"] to 180 - this["hdg"].
	
	return 0.
}

// State 4
function LaunchGuidance_Pitch
{
	parameter this.
	
	local ap is this["ap"].
	local hdg is this["tgtHdg"].
	
	set this["platform"]["pitch"] to -((apoapsis / ap) * 90) * cos(tgtHdg).
	set this["platform"]["yaw"] to -((apoapsis / ap) * 90) * sin(tgtHdg).
	set this["platform"]["roll"] to 180 - tgtHdg.
	
	// TODO: Throttle down as Ap approaches target Ap. 
	if apoapsis >= this["ap"]
	{
		this["lv"]["shutdown"](this["lv"]).
		this:clear().
	}
	
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
