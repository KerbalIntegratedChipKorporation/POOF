// exec.ks

Include("global").
Include("controller").

function Exec_New
{	
	local this is NewController("exec", Exec_setup@, Exec_loop@, Exec_Err@).
		
	this:add("controllers", lexicon()).
	this:add("controllerList", list()).
	this:add("currentController", -1).
	
	this:add("EnableController", Exec_EnableController@).
	this:add("StartController", Exec_StartController@).
	this:add("GetController", Exec_GetController@).
	this:add("ControllerCall", Exec_Call@).
	
	return this.
}

function Exec_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

function Exec_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	if this["controllerList"]:length > this["currentController"] + 1
	{
		set this["currentController"] to this["currentController"] + 1.
	}
	else
	{
		set this["currentController"] to -1.
		
		// Reached end of controller list.
		return 4.
	}
	
	// Get the current controller. This is the one we'll be executing.
	local ctrlName is this["controllerList"][this["currentController"]].
	local ctrl is this["controllers"][ctrlName].
	
	// Check if the controller is null. If it is, remove it from the list.
	// This is our garbage collection method.
	if IsNullController(ctrl)
	{
		this["controllerList"]:remove(this["currentController"]).
		set this["currentController"] to this["currentController"] - 1.
		this["controllers"]:remove(ctrlName).
		
		// Encountered null controller and removed it.
		return 5.
	}
	
	if ctrl["enabled"] = true
	{
		return ctrl["loop"](ctrl).
	}
	else
	{
		// Controller is disabled.
		return 6.
	}
	
	return 0.
}

function Exec_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

function Exec_EnableController
{
	parameter this.
	parameter name.
	
	if this["controllers"]:haskey(name)
	{
		set obj to this["controllers"][name].
		set obj["enabled"] to true.
		obj["setup"](obj).
	}
}

function Exec_StartController
{
	parameter this.
	parameter name.
	parameter object.
	
	if this["controllerList"]:contains(name)
	{
		// The controller already exists. 
		// Start the controller.
		set object["enabled"] to true.
		object["setup"](object).
		
		return false.
	}
	else
	{
		// The controller does not exist.
		// Add the controller to executive.
		this["controllers"]:add(name, object).
		this["controllerList"]:add(name).
		
		// We're going to add a new variable to the controller to tell it
		// where its executive program is. That way, it can access its exec
		object:add("exec", this).
		
		// Start the controller.
		set object["enabled"] to true.
		object["setup"](object).
		
		return true.
	}
}

function Exec_GetController
{
	parameter this.
	parameter name.
	
	if this["controllerList"]:contains(name)
	{
		return this["controllers"][name].
	}
	else
	{
		return lexicon().
	}
}

function Exec_Call
{
	parameter this.
	parameter ctrlName.
	parameter funcName.
	
	local ctrl is Exec_GetController(ctrlName).
	return ctrl["call"](ctrl, funcName).
}