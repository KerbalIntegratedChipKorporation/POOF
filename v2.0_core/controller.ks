// controller.ks
// Handles object operations

// Creates a new active controller and returns it.
function NewController
{
	parameter setup.
	parameter loop.
	parameter err.
	
	return lexicon("enabled", true, "setup", setup, "loop", loop, "err", err, "call", CTRL_Call@).
}

// Checks if a controller is null. A controller is null
// if it contains no members.
function IsNullController
{
	parameter ctrl.
	
	return ctrl:length = 0.
}

// Returns a null controller
function NullController
{
	return lexicon().
}

function CTRL_Call
{
	parameter ctrl.
	parameter funcName.
	
	if not ctrl:haskey(funcName)
	{
		// Controller does not contain the function.
		return 2.
	}
	
	set func to ctrl[funcName].
	if func:typename <> "UserDelegate"
	{
		// Function name is not a valid function in the controller.
		return 3.
	}
	
	set errorCode to ctrl[funcName](ctrl).
	
	if errorCode <> 0
	{
		ctrl["Err"](ctrl, errorCode, funcName).
	}
	
	return 0.
}