// controllerbase.ks

Include("controller").

function CTRL_New
{
	// Add parameters here
	// parameter x.
	
	local this is NewController(CTRL_setup@, CTRL_loop@, CTRL_Err@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function CTRL_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function CTRL_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	
	return 0.
}

function CTRL_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}
