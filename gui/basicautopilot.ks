// basicautopilot.ks
// GUI for basic autopilot operations (HOLD and LVL)
// HOLD will hold the aircraft's altitude.
// LVL will keep the wings level

Include("controller").

function Autopilot_New
{
	// This operates under the assumption that you're using the FSM guidance
	parameter guidance.
	
	local this is NewController("Autopilot", Autopilot_setup@, Autopilot_loop@, Autopilot_Err@, Autopilot_GetData@).

	this:add("gd", guidance).

	this:add("wnd", GUI(0)).
	this:add("chkHold", this["wnd"]:addcheckbox("HOLD", false)).
	this:add("chkLvl", this["wnd"]:addcheckbox("LVL", false)).
	
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
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function Autopilot_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	
	
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
