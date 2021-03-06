// launchvehicle.ks

Include("controller").
Include("lvstage").

function LaunchVehicle_New
{
	// Add parameters here
	parameter stageInfo.
	
	local this is NewController("launchvehicle", LaunchVehicle_setup@, LaunchVehicle_loop@, LaunchVehicle_Err@, LaunchVehicle_GetData@).
	
	// Add arguments to the controller
	// this:add("x", x).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	// Add state variables to the controller
	this:add("stageId", 0).
	
	this:add("stages", list()).
	
	from { local i is 0. } until i = stageInfo:length step { set i to i + 1. } do
	{
		local s is Stage_New(i, stageinfo[i]).
		set s["enabled"] to false.
		this["stages"]:add(s).
	}
	
	this:add("stage", LaunchVehicle_Stage@).
	this:add("ignition", LaunchVehicle_Ignition@).
	this:add("shutdown", LaunchVehicle_Shutdown@).
	this:add("addstage", LaunchVehicle_AddStage@).
	this:add("dostaging", LaunchVehicle_DoStaging@).
	
	return this.
}

function LaunchVehicle_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	
	return 0.
}

function LaunchVehicle_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	local s is LaunchVehicle_Stage(this).
	if s["enabled"]
	{
		s["loop"](s).
	}
	
	return 0.
}

function LaunchVehicle_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

// This function is intended to return telemetry data.
function LaunchVehicle_GetData
{
	parameter this.
	
	local s is LaunchVehicle_Stage(this).
	local data is s["getdata"](s).
	
	return data.
}

function LaunchVehicle_AddStage
{
	parameter this.
	parameter stageInfo.
	
	local s is Stage_New(i, stageinfo[i]).
	set s["enabled"] to false.
	this["stages"]:add(s).
}

function LaunchVehicle_Stage
{
	parameter this.
	
	return this["stages"][this["stageId"]].
}

function LaunchVehicle_Ignition
{
	parameter this.
	
	local s is LaunchVehicle_Stage(this).
	s["ignition"](s).
}

function LaunchVehicle_Shutdown
{
	parameter this.
	
	local s is LaunchVehicle_Stage(this).
	s["shutdown"](s).
}

function LaunchVehicle_DisableStage
{
	parameter this.
	
	local s is LaunchVehicle_Stage(this).
	set s["enabled"] to false.
}

function LaunchVehicle_DoStaging
{
	parameter this.

	stage.
	wait 0.
	set this["stageId"] to this["stageId"] + 1.
}