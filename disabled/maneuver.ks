// maneuver.ks

Include("controller").

function maneuver_New
{
	// Add parameters here
	// parameter x.
	parameter guidance.
	parameter lv.
	parameter t.
	parameter twr.
	parameter len.
	parameter dir.
	
	local this is NewController("maneuver", maneuver_setup@, maneuver_loop@, maneuver_Err@, maneuver_GetData@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	this:add("time", t).
	this:add("twr", twr).
	this:add("len", len).
	this:add("dir", dir).
	this:add("shutdownTime", t + len).
	
	this:add("active", false).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function maneuver_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function maneuver_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	if this["active"]
	{
		// Wait for shutdown.
		if time:seconds > this["shutdownTime"]
		{
			lv["shutdown"](lv).
			set this["active"] to false.
		}
	}
	else
	{
		set 
		if time:seconds > this["time"]
		{
			lv["Ignition"](lv).
			set this["active"] to true.
		}
	}
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function maneuver_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function maneuver_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}
