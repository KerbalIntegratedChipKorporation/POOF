// Telemetry.ks

Include("controller").

function Telemetry_New
{
	// Add parameters here
	// parameter x.
	
	local this is NewController("Telemetry", Telemetry_setup@, Telemetry_loop@, Telemetry_Err@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).

	// Frame function lexicon format: [obj, "func"]
	this:add("frameFuncs", lexicon()).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function Telemetry_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	if exists("1:/telemetry.txt")
	{
		deletepath("1:/telemetry.txt").
	}
	create("1:/telemetry.txt").
	this:add("telemFile", open("1:/telemetry.txt")).
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function Telemetry_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	
	local telemFile is this["telemFile"].
	telemFile:clear().
	
	from {local i is 0. } until i = this["frameFuncs"]:length step { set i to i + 1. } do
	{
		local obj is this["frameFuncs"]:keys[i].
		local func is this["frameFuncs"][obj].
		
		local frame is obj[func](obj).
		
		from {local j is 0. } until j = frame:length step { set j to j + 1. } do
		{
			local key is frame:keys[j].
			telemFile:write(key).
			telemFile:write(":").
			telemFile:writeln(frame[key]:tostring()).
		}
	}
	
	// Double check before actually transmitting!
	if homeconnection:isconnected()
	{
		copypath("1:/telemetry.txt", "0:/telemetry.txt").
	}
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function Telemetry_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}
