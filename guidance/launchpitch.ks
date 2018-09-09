// launchpitch.ks

Include("controller").

function LaunchPitch_New
{
	parameter platform.
	parameter lv.
	parameter ap.
	parameter hdg.
	
	local this is NewController("launchpitch", LaunchPitch_setup@, LaunchPitch_loop@, LaunchPitch_Err@, LaunchPitch_GetData@).
	
	this:add("platform", platform).
	this:add("ap", ap).
	this:add("lv", lv).
	this:add("hdg", hdg).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function LaunchPitch_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function LaunchPitch_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	if apoapsis > this["ap"]
	{
		set this["enabled"] to false.
		
		this["lv"]["shutdown"](this["lv"]).
		this:clear().
	}
	else
	{
		local ap is this["ap"].
		local hdg is this["hdg"].
		
		set this["platform"]["pitch"] to -((apoapsis / ap) * 90) * cos(hdg).
		set this["platform"]["yaw"] to -((apoapsis / ap) * 90) * sin(hdg).
		set this["platform"]["roll"] to 180 - hdg.
	}
	
	return 0.
}

function LaunchPitch_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function LaunchPitch_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}