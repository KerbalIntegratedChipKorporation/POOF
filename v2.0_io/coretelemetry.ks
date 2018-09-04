// coretelemetry.ks

Include("controller").
Include("navball").

function CoreTelemetry_New
{
	// Add parameters here
	// parameter x.
	
	local this is NewController("CoreTelemetry", CoreTelemetry_setup@, CoreTelemetry_loop@, CoreTelemetry_Err@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function CoreTelemetry_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function CoreTelemetry_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	
	return 0.
}

// This function is called when the controller raises an error 
// and it is caught by the executive program
function CoreTelemetry_Err
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

function CoreTelemetry_GetData
{
	parameter this.
	
	local data is lexicon().
	
	data:add("ID", this["exec"][""]
	data:add("UT", time:seconds).
	
	if missiontime = 0
	{
		data:add("MET", State_GetRegister("Countdown")).
	}
	else
	{
		data:add("MET", floor(missiontime)).
	}
	
	local distPerDeg is (2 * 600000 * constant():pi) / 360.
	local downrange is sqrt(((padPos:lat - ship:geoposition:lat)^2) + (padPos:lng - ship:geoposition:lng)^2) * distPerDeg.
	// This distance is in meters.
	
	data:add("Prog", State_GetRegister("Prog")).
	data:add("Mass", round(ship:mass, 2)).
	data:add("Alt", round(ship:altitude, 0)).
	data:add("Downrange", round(downrange, 2)).
	data:add("AP", round(ship:obt:apoapsis, 2)).
	data:add("Pe", round(ship:obt:periapsis, 2)).
	data:add("Lat", round(ship:geoposition:lat, 2)).
	data:add("Lng", round(ship:geoposition:lng, 2)).
	data:add("Q", round(ship:q * constant:ATMtokPa, 2)).
	data:add("Pitch", round(Navball_GetPitch(), 2)).
	data:add("Heading", round(Navball_GetCompass(), 2)).
	data:add("Roll", round(Navball_GetRoll(), 2)).
	data:add("VecX", round(facing:vector:x, 2)).
	data:add("VecY", round(facing:vector:y, 2)).
	data:add("VecZ", round(facing:vector:z, 2)).
	
	return data.
}