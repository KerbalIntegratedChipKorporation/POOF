// launchroll.ks

Include("controller").

function LaunchRoll_New
{
	parameter platform.
	parameter lv.
	parameter hdg.
	parameter rate.
	parameter pitchProg.	// pitch program name
	
	local this is NewController(LaunchRoll_setup@, LaunchRoll_loop@, LaunchRoll_Err@).
	
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
	
	// Do your control loop here
	if altitude > 2000
	{
		if this["hdg"] - this["target"] < 1.0
		{
			set this["enabled"] to false.
			this["exec"]["enablecontroller"](this["exec"], this["pitchProg"]).
			this:clear().
		}
		else
		{
			local deltaTime is time:seconds - this["time"].
			local deltaRate is this["rate"] * deltaTime.
			
			set this["hdg"] to this["hdg"] + deltaRate.
			set this["platform"]["roll"] to this["hdg"].
		}
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


