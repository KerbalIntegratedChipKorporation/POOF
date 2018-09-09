// idgen.ks
// Generates an ID for any purpose needed in a given loop instance.

Include("controller").

function IDGen_New
{
	// Add parameters here
	// parameter x.
	
	local this is NewController("IDGen", IDGen_setup@, IDGen_loop@, IDGen_Err@, IDGen_GetData@).
	
	this:add("id", random()).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function IDGen_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function IDGen_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	set this["id"] to random().
	
	return 0.
}

function IDGen_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function IDGen_GetData
{
	parameter this.
	
	local data is lexicon().
	
	data:add("id", this["ID"]).
	
	return data.
}
