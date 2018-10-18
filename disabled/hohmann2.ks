// Hohmann2.ks
// Performs the second half of a Hohmann transfer orbit.
// Circularizes an orbit

Include("controller").

function Hohmann2_New
{
	// Add parameters here
	// parameter x.
	parameter platform.
	parameter lv.
	parameter tgtThrottle.
	parameter roll.
	
	local this is NewController("Hohmann2", Hohmann2_setup@, Hohmann2_loop@, Hohmann2_Err@, Hohmann2_GetData@).
	
	this:add("platform", platform).
	this:add("lv", lv).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	this:add("tgtThrottle", tgtThrottle).
	this:add("roll", roll).
	
	this:add("tgtVelocity", 0).
	this:add("velAtAp", 0).
	this:add("deltaV", 0).
	
	this:add("m0", ship:mass).
	this:add("m1", 0).
	this:add("deltaM", 0).
	this:add("mdot", 0).
	this:add("burnTime", 0).
	this:add("ignitionTime", 0).
	this:add("countdown", lexicon()).

	this:add("ignition", Hohmann2_Ignition@).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function Hohmann2_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	set this["tgtVelocity"] to ship:body:radius * sqrt(9.807 / (ship:body:radius + apoapsis)).
	set this["velAtAp"] to velocityat(ship, time + eta:apoapsis):orbit:mag.
	set this["deltaV"] to this["tgtVelocity"] - this["velAtAp"].
	
	set s to lv["stage"].
	set isp to s["isp"](s).
	set thrust to s["thrust"](s).
	
	set this["m0"] to ship:mass.
	set this["m1"] to this["m0"] * (constant:e ^ (-this["deltaV"] / (isp * 9.807))).
	set this["deltaM"] to this["m0"] - this["m1"].
	set this["mdot"] to (thrust * this["tgtThrottle"]) / (isp * 9.807).
	set this["burnTime"] to this["deltaM] / this["mdot"].
	
	set this["ignitionTime"] to time + eta:apoapsis - (this["burnTime"] / 2).
	
	this["platform"]["prograde"](this["platform"], roll).
	
	//set this["countdown"] to Countdown_New((time - this["ignitionTime"]):seconds, this, "ignition", list(s["ullageTime"] + s["spoolTime"])).
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function Hohmann2_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function Hohmann2_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function Hohmann2_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}

function Hohmann2_Ignition
{
	parameter this.
	
	this["lv"]["ignition"](this["lv"]).
}