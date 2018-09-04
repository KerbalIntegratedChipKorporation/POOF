// lvstage.ks

Include("controller").
Include("timer").
Include("enum"). 

global Enum_Ignition is list("none", "rcs", "ullageMotor").
global Enum_IgnitionStatus is list("shutdown", "ullage", "spool", "ignition").

function Stage_New
{
	parameter stageNumber.
	parameter stageInfo.
	
	local this is NewController("stage", Stage_setup@, Stage_loop@, Stage_Err@).

	// Add arguments to the controller
	// this:add("x", x).
	this:add("number", stageNumber).
	this:add("hasClamps", stageInfo["hasClamps"]).
	this:add("spoolTime", stageInfo["spoolTime"]).
	this:add("timer", Timer_New(stageInfo["spoolTime"], this, "timerElapsed", false)).
	this:add("timerElapsed", Stage_TimerElapsed@).
	this:add("engines", list()).
	this:add("ullageMotor", list()).
	this:add("throttle", 1.0).
	this:add("ignitionStatus", "shutdown").
	this:add("twr", stageInfo["twr"]).
	
	list engines in shipengines.
	for eng in shipengines
	{
		if eng:tag:startswith(stageInfo["tag"])
		{
			this["engines"]:add(eng).
		}
		if stageInfo["umTag"] <> ""
		{
			if eng:tag = stageInfo["umTag"]
			{
				this["ullageMotor"]:add(eng).
			}
		}
	}
	
	this:add("ullageType", stageInfo["ullageType"]).
	this:add("ullageTime", stageInfo["ullageTime"]).
	
	// Add optional user functions to the controller
	// this:add("foo" foo@).
	
	// Add state variables to the controller
	// this:add("bar", 0).
	
	set this["timer"]["enabled"] to false.
	this:add("rcsState", rcs).
	
	this:add("ignition", Stage_Ignition@).
	this:add("shutdown", Stage_Shutdown@).
	
	return this.
}

function Stage_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your setup here
	Stage_SetStatus(this, "shutdown").
	set this["timer"]["enabled"] to false.
	
	return 0.
}

function Stage_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	// Do your control loop here
	// THE STAGE SHOULD BE ENABLED VIA THE LAUNCHVEHICLE CONTROLLER
	// When the stage is enabled, this loop will begin. It is assumed
	// that the activation of a stage is meant to activate the engine(s)
	// associated with the stage, and therefore automatic ullage burn
	// should occur with the provided method.
	
	// If the stage has clamps, it is assumed that the stage is a first
	// stage, and the spoolTime will be allowed to elapse before the
	// clamps are released. This will be done using a timer.
	
	// Switch throttle control.
	//unlock throttle.
	
	// Timer
	local timer is this["timer"].
	if timer["enabled"]
	{
		timer["loop"](timer).
	}
	
	// Throttle
	local tgtThrustMass is ship:mass * this["twr"].
	local tgtThrustForce is tgtThrustMass * 9.81.
	local availableThrust to ship:availablethrust.
	if availableThrust > 0
	{
		set this["throttle"] to tgtThrustForce / availablethrust.
	}
	else
	{
		set this["throttle"] to 0.
	}

	// Handle ignition sequence
	if Stage_IgnitionType(this, "rcs")
	{
		Stage_RCSUllage(this).
	}
	else if Stage_IgnitionType(this, "ullageMotor")
	{
		Stage_UllageMotor(this).
	}
	else if Stage_IgnitionType(this, "none")
	{
		Stage_Normal(this).
	}
	
	return 0.
}

function Stage_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

function Stage_Ignition
{
	parameter this.
	
	set this["enabled"] to true.
	this["setup"](this).
}

function Stage_Shutdown
{
	parameter this.

	Stage_SetStatus(this, "shutdown").
	set this["throttle"] to 0.
	for e in this["engines"]
	{
		e:shutdown().
	}
}

function Stage_TimerElapsed
{
	parameter this.
	
	if Stage_Status(this, "ullage")
	{
		Stage_SetStatus(this, "spool").
		lock throttle to this["throttle"].
	}
	else if Stage_Status(this, "spool")
	{
		Stage_SetStatus(this, "ignition").
	}
}

function Stage_Normal
{
	parameter this.
	
	if Stage_Status(this, "shutdown")
	{
		unlock throttle.
		lock throttle to this["throttle"].
		Stage_SetStatus(this, "spool").
		
		Stage_StartTimer(this, this["spoolTime"]).
		
		for e in this["engines"]
		{
			e:activate().
		}
	}
	else if Stage_Status(this, "ignition")
	{
		if this["hasClamps"]
		{
			stage.
			set this["hasClamps"] to false.
		}
	}
}

function Stage_RCSUllage
{	
	parameter this.
	
	if Stage_Status(this, "shutdown")
	{
		unlock throttle.
		set this["rcsState"] to rcs.
		set this["ignitionStatus"] to "ullage".
		rcs on.
		Stage_StartTimer(this, this["ullageTime"]).
		
		set ship:control:fore to 1.
	}
	else if Stage_Status(this, "spool")
	{
		for e in this["engines"]
		{
			e:activate().
		}
		lock throttle to this["throttle"].
		
		Stage_StartTimer(this, this["spoolTime"]).
	}
	else if Stage_Status(this, "ignition")
	{
		set ship:control:fore to 0.
		set rcs to this["rcsState"].
	}
}

function Stage_UllageMotor
{	
	parameter this.
	
	if Stage_Status(this, "shutdown")
	{
		unlock throttle.
		Stage_StartTimer(this, this["ullageTime"]).
		
		for e in this["ullageMotor"]
		{
			e:activate().
		}
	}
	else if Stage_Status(this, "spool")
	{
		for e in this["engines"]
		{
			e:activate().
		}
		lock throttle to this["throttle"].
		
		Stage_SetStatus(this, "ignition").
	}
}

function Stage_Status
{
	parameter this.
	parameter s.
	
	return Enum_CompareValues(Enum_IgnitionStatus, this["ignitionStatus"], s).
}

function Stage_SetStatus
{
	parameter this.
	parameter s.
	
	set this["ignitionStatus"] to s.
}

function Stage_IgnitionType
{
	parameter this.
	parameter s.
	
	return Enum_CompareValues(Enum_Ignition, this["ullageType"], s).
}

function Stage_StartTimer
{
	parameter this.
	parameter t.
	
	set this["timer"]["interval"] to t.
	this["timer"]["setup"](this["timer"]).
}