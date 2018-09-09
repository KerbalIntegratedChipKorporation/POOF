// guidance.ks

Include("controller").

function Guidance_New
{
	// Add parameters here
	// parameter x.
	
	local this is NewController("guidance", Guidance_setup@, Guidance_loop@, Guidance_Err@, Guidance_GetData@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	this:add("dir", up * R(0,0,0)).
	this:add("pitch", 0).
	this:add("yaw", 0).
	this:add("roll", 180).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function Guidance_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	lock steering to this["dir"].
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function Guidance_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	set this["dir"] to up * R(this["pitch"], this["yaw"], this["roll"]).
	
	return 0.
}

function Guidance_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function Guidance_GetData
{
	parameter this.
	
	local data is lexicon().
	
	data:add("tgtPitch", this["pitch"]).
	data:add("tgtYaw", this["yaw"]).
	data:add("tgtRoll", this["roll"]).
	
	local dirVec is this["dir"]:vector.
	
	data:add("tgtVecX", dirVec:x).
	data:add("tgtVecY", dirVec:y).
	data:add("tgtVecZ", dirVec:z).
	
	return data.
}
