// maneuvermanager.ks

Include("controller").

function maneuvermanager_New
{
	// Add parameters here
	// parameter x.
	parameter guidance.
	parameter lv.
	
	local this is NewController("maneuvermanager", maneuvermanager_setup@, maneuvermanager_loop@, maneuvermanager_Err@, maneuvermanager_GetData@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	this:add("guidance", guidance).
	this:add("lv", lv).
	this:add("maneuvers", queue()).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function maneuvermanager_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function maneuvermanager_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function maneuvermanager_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function maneuvermanager_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	local current is maneuvermanager_Current().
	if IsNullController(current)
	{
		if this["maneuvers"]:length > 0
		{
			this["maneuvers"]:pop().
		}
	}
	else
	{
		current["loop"](current).
	}
	
	return data.
}

function manuevermanager_Enqueue
{
	parameter this.
	parameter t.
	parameter twr.
	parameter len.
	parameter pitch, yaw, roll.
	
	this["manuevers"]:push(this["guidance"], this["lv"], t, twr, len, r(pitch, yaw, roll)).
}

function maneuvermanager_Current
{
	parameter this.
	
	if this["manuevers"]:length > 0
	{
		return this["maneuvers"]:peek().
	}
	else
	{
		return NullController().
	}
}
