// launchguidance.ks

Include("controller").

function LaunchGuidance_New
{
	parameter platform.
	parameter lv.
	
	local this is NewController(LaunchGuidance_setup@, LaunchGuidance_loop@, LaunchGuidance_Err@).
	
	this:add("platform", platform).
	this:add("lv", lv).
	
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
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function LaunchGuidance_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	local lv is this["lv"].
	local s is lv["stage"](lv).
	
	if altitude > 2000
	{
		//set this["enabled"] to false.
		this:clear().
	}
	else if s["enabled"] = false
	{
		set this["platform"]["dir"] to up * R(0,0,180).
		this["lv"]["ignition"](this["lv"]).
	}
	
	return 0.
}

function LaunchGuidance_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}
