// nodeman.ks

Include("controller").

function nodeman_New
{
	// Add parameters here
	parameter guidance.
	parameter lv.
	
	local this is NewController("nodeman", nodeman_setup@, nodeman_loop@, nodeman_Err@, nodeman_GetData@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	this:add("guidance", guidance).
	this:add("lv", lv).
	this:add("nodeActive", false).
	this:add("ignitionTime", 0).
	this:add("shutdownTime", 0).
	
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

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function nodeman_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	local lv is this["lv"].
	local gd is this["guidance"].
	local stg is lv["stage"](lv).
	
	// Do your control loop here
	if hasnode
	{
		local nd is nextnode.
		
		if this["nodeActive"]
		{
			if time:seconds > this["shutdownTime"]
			{
				print "SHUTDOWN".
				// Shutdown engine
				lv["shutdown"](lv).
			
				// Relock to guidance control
				gd["lock"](gd).
				
				set this["nodeActive"] to false.
				remove nd.
				set this["ignitionTime"] to 0.
			}
		}
		else
		{
			if this["ignitionTime"] = 0
			{
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
				
					// take control from guidance
					unlock steering.
					lock steering to nd.
				}
				else
				{
					// todo: throw an error
					print "MaxAcc is 0.".
				}
			}
			else if time:seconds >= this["ignitionTime"]
			{
				print "IGNITION!".
				lv["ignition"](lv).
				set this["nodeActive"] to true.
			}
		}
	}
	
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
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}

