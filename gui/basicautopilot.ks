// basicautopilot.ks
// GUI for basic autopilot operations (HOLD)
// HOLD will hold the aircraft's altitude and heading.

Include("controller").
Include("navball").

function Autopilot_New
{
	// This operates under the assumption that you're using the FSM guidance
	parameter guidance.
	
	local this is NewController("Autopilot", Autopilot_setup@, Autopilot_loop@, Autopilot_Err@, Autopilot_GetData@).

	this:add("gd", guidance).
	this:add("lockAltitude", 0).

	this:add("wnd", GUI(0)).
	this:add("chkHold", this["wnd"]:addcheckbox("HOLD", false)).
	set this["chkHold"]:ontoggle to Autopilot_HoldToggle@.
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function Autopilot_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// We have to set the STATIC_AUTOPILOT variable in global to this.
	// That way we can get the object information when the autopilot GUI is executed.
	set STATIC_AUTOPILOT to this.
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function Autopilot_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	
	// We're not going to actually do a control loop here because it will
	// waste processing time. Instead of doing a state check and operating 
	// off of that value, we're going to wait for the user to use the GUI
	// and use the GUI state change to institute the change in control.
	
	// DOWNSIDE: We have to use a global static variable (stored in global.ks)
	// that holds the currently active autopilot. The GUI functions don't have
	// the capacity to have THIS as a parameter (duh!) so the GUI function
	// is going to have to grab the THIS state from STATIC_AUTOPILOT.
	// STATIC_AUTOPILOT should be set in the SETUP function.
	
	// WARNING: If you attempt to load more than one autopilot, the last one loaded
	// will override the STATIC_AUTOPILOT of any previously loaded one once the SETUP
	// function runs.
	
	// ONE THING WE HAVE TO DO HERE!:
	// We should manage the pitch so that our altitude is stable.
	// When the autopilot is turned on, the lock altitude is set to the current altitude.
	
	// Pitch finder parameters:
	// - The maximum altitude error is 30 meters (about 100 feet). Above this value,
	// 	the pitch finder will be active.
	// - The maximum vertical speed is +/- 15 meters per second
	// - The maximum pitch is +/- 15 degrees from horizontal
	
	local gd is this["gd"].
	
	if this["chkHold"]:pressed
	{
		// If altErr is positive, the lock altitude is greater than the current altitude.
		// Otherwise, the lock altitude is less than the current altitude.
		local altErr is this["lockAltitude"] - altitude.
		local absErr is abs(altErr).
		local errSign is 0.
		if altErr >= 0
		{
			set errSign to 1.
		}
		else
		{
			set errSign to -1.
		}
		
		// ALTERNATE VERSION:
		// local errSign is 0 { if altErr >= 0 { set errSign to 1. } else { set errSign to -1. }}:call().
	
		// Check if the error value is greater than the maximum error of 30 meters
		if abs(altErr) > 30
		{
			// The pitch coefficient is the minimum of (altitude error / 30 meters) and 1.0.
			// This means that the pitch coefficient will be 1 or the maxiumum
			local pitchCoeff is min(absErr, 1.0) * errSign.
			
			// Calculate the pitch we want based on our current pitch and relative surface speed
			local theta is Navball_GetPitch().
			local r is ship:velocity:surface:mag.
			local thetaSign is 0.
			if thetaSign >= 0
			{
				set thetaSign to 1.
			}
			else
			{
				set thetaSign to -1.
			}
			
			local x is r * cos(theta).
			local y is r * sin(theta).
			
			// Calculate new X and Y from the current vector, 
			// where the maximum vertical speed (Y) is 15 m/s.
			set x to x + y - 15.
			set y to 15.
			
			set r to sqrt(x^2 + y^2).
			set theta to arctan2(y, x).
			
			set gd["pitch"] to min(15 * pitchCoeff, theta).
		}
	}
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function Autopilot_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function Autopilot_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}

/////////////////////////////////////////////////////////////
// GUI Functions
/////////////////////////////////////////////////////////////

function Autopilot_HoldToggle
{
	parameter value.
	
	// Retrieve THIS
	local this is STATIC_AUTOPILOT. 
	local gd is this["gd"].
	
	if value
	{
		set gd["pitch"] to 0.
		set gd["roll"] to 0.
		set gd["yaw"] to Navball_GetCompass().
		set this["lockAltitude"] to ship:altitude.
		
		gd["setmode"](gd, "Heading").
		gd["lock"](gd).
	}
	else
	{
		gd["unlock"](gd).
		
		// Play autopilot disconnect tone.
		local voice is getvoice(0).
		voice:play(
			list(
				note(500, 2),
				note(0, 0.5),
				note(500, 2),
				note(0, 0.5),
				note(500, 2)
			)
		).
	}
}
