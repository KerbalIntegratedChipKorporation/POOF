// launchroll.ks

Include("controller").

function LaunchRoll_New
{
	parameter platform.
	parameter lv.
	parameter hdg.
	parameter rate.
	parameter pitchProg.	// pitch program name
	
	local this is NewController("launchroll", LaunchRoll_setup@, LaunchRoll_loop@, LaunchRoll_Err@, LaunchRoll_GetData@).
	
	this:add("platform", platform).
	this:add("lv", lv).
	this:add("target", hdg).
	this:add("hdg", 0).
	this:add("rate", rate).
	this:add("time", time:seconds).
	this:add("pitchProg", pitchProg).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function LaunchRoll_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function LaunchRoll_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	if altitude > 2000
	{
		local deltaTime is time:seconds - this["time"].
		local deltaRoll is this["rate"] * deltaTime.	
	
		set this["hdg"] to this["hdg"] + deltaRoll.
		local diff is abs(this["hdg"] - this["target"]).
		if diff < abs(deltaRoll * 2)
		{
			set this["hdg"] to this["target"].
		}
		set this["platform"]["roll"] to 180 - this["hdg"].
	}
	
	if altitude > 3500
	{
		set this["enabled"] to false.
		this["exec"]["enablecontroller"](this["exec"], this["pitchProg"]).
		this:clear().
	}
	
	if this:haskey("time")
	{
		set this["time"] to time:seconds.
	}

	return 0.
}

function LaunchRoll_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function LaunchRoll_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}