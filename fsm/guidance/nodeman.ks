// nodeman.ks

Include("statemachine").
Include("navball").

function nodeman_New
{
	// Add parameters here
	
	// This assumes that the guidance system is the FSM version
	parameter guidance.
	parameter lv.
	
	local this is NewStateMachine("nodeman", nodeman_setup@, nodeman_Err@, nodeman_GetData@).
	
	set this["states"][0] to nodeman_WaitForNode@.
	this["states"]:add(nodeman_SetupBurn@).
	this["states"]:add(nodeman_WaitForIgnition@).
	this["states"]:add(nodeman_WaitForShutdown@).
	
	this:add("guidance", guidance).
	this:add("lv", lv).
	this:add("nodeActive", false).
	this:add("ignitionTime", 0).
	this:add("shutdownTime", 0).
	this:add("nd", node(0,0,0,0)).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function nodeman_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function nodeman_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function nodeman_GetData
{
	parameter this.
	
	local data is lexicon().
	
	local nd is this["nd"].
	
	data:add("hasNode", hasnode).
	data:add("nodeActive", nodeActive).
	data:add("node state", this["state"]).
	if hasnode
	{
		data:add("node dV_X", nd:deltav:x).
		data:add("node dV_Y", nd:deltav:y).
		data:add("node dV_Z", nd:deltav:z).
		data:add("node dV_mag", nd:deltav:mag).
		data:add("node pitch", Navball_GetPitchVec(nd:deltav)).
		data:add("node hdg", Navball_GetCompassVec(nd:deltav)).
		data:add("node prograde dV", nd:prograde).
		data:add("node radialout dV", nd:radialout).
		data:add("node normal dV", nd:normal).
		data:add("node eta", nd:eta).
		data:add("node ignitionTime", this["ignitionTime"]).
		data:add("node shutdownTime", this["shutdownTime"]).
	}
	else
	{
		data:add("node dV_X", "NaN").
		data:add("node dV_Y", "NaN").
		data:add("node dV_Z", "NaN").
		data:add("node dV_mag", "NaN").
		data:add("node pitch", "NaN").
		data:add("node hdg", "NaN").
		data:add("node prograde dV", "NaN").
		data:add("node radialout dV", "NaN").
		data:add("node normal dV", "NaN").
		data:add("node eta", "NaN").
		data:add("node ignitionTime", "NaN").
		data:add("node shutdownTime", "NaN").
	}
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}

////////////////////////////////////////////////////////////////
// STATES //
////////////////////////////////////////////////////////////////

// state 0
function nodeman_WaitForNode
{
	parameter this.
	
	if hasnode
	{
		set this["state"] to 1.
	}
	
	return 0.
}

// state 1
function nodeman_SetupBurn
{
	parameter this.
	
	local lv is this["lv"].
	local gd is this["guidance"].
	local stg is lv["stage"](lv).
	local nd is nextnode.
	
	set this["nd"] to nextnode.
	
	// set throttle mode to ACC.
	local stg is lv["stage"](lv).
	local maxAcc is stg["thrust"](stg) / ship:mass.
	
	set stg["throttleMode"] to "override".
	set stg["throttle"] to 0.
	
	if maxAcc > 0
	{
		local burnTime is nd:deltav:mag / maxAcc.
		set this["ignitionTime"] to time:seconds + nd:eta - (burnTime / 2).
		set this["shutdownTime"] to time:seconds + nd:eta + (burnTime / 2).
		
		print "Burn time: " + burnTime.
		print "Ignition ETA: " + (this["ignitionTime"] - time:seconds).
		print "Shutdown ETA: " + (this["shutdownTime"] - time:seconds).
	
		// Change to vector guidance mode.
		set gd["vector"] to nd:deltav.
		gd["setmode"](gd, "Vector").
	}
	else
	{
		// todo: throw an error
		print "MaxAcc is 0.".
	}
	
	set this["state"] to 2.
	
	return 0.
}

// state 2
function nodeman_WaitForIgnition
{
	parameter this.
	
	if time:seconds >= this["ignitionTime"]
	{
		local lv is this["lv"].
		lv["ignition"](lv).
		set this["nodeActive"] to true.
		set this["state"] to 3.
	}
}

// state 3
function nodeman_WaitForShutdown
{
	parameter this.
	
	if time:seconds > this["shutdownTime"]
	{
		lv["shutdown"](lv).
		set this["nodeActive"] to false.
		remove this["nd"].
		set this["ignitionTime"] to 0.
		set this["state"] to 0.
	}
}