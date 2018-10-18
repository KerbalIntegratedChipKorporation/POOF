// lvstage.ks

Include("controller").
Include("timer").
Include("enum"). 

global Enum_Ignition is list("none", "rcs", "ullageMotor").
global Enum_IgnitionStatus is list("shutdown", "ullage", "spool", "ignition").
global Enum_ThrottleMode is list ("override", "twr", "acc").

function Stage_New
{
	parameter stageNumber.
	parameter stageInfo.
	
	local this is NewController("stage", Stage_setup@, Stage_loop@, Stage_Err@, Stage_GetData@).

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
	this:add("throttleParam", stageInfo["twr"]).
	this:add("throttleMode", "twr").
	this:add("stageInfo", stageInfo).
	
	list engines in shipengines.
	for eng in shipengines
	{
		if eng:tag = stageInfo["tag"]
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
	this:add("isp", Stage_Isp@).
	this:add("thrust", Stage_Thrust@).
	this:add("arm", Stage_Arm@).
	
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
	local availableThrust is Stage_Thrust(this).
	if this["throttleMode"] = "acc"
	{
		local maxAcc is availableThrust / ship:mass.
		set this["throttle"] to this["throttleParam"] / maxAcc.
	}
	else if this["throttleMode"] = "twr"
	{
		local tgtThrustMass is ship:mass * this["throttleParam"].
		local tgtThrustForce is tgtThrustMass * 9.81.
		
		if availableThrust > 0
		{
			set this["throttle"] to tgtThrustForce / availablethrust.
		}
		else
		{
			set this["throttle"] to 0.
		}
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

// This function is intended to return telemetry data.
function Stage_GetData
{
	parameter this.
	
	local data is lexicon().
	
	data:add("stageNumber", this["number"]).
	data:add("stageEnabled", this["enabled"]).
	data:add("stageTimerDelta", this["timer"]["delta"]).
	data:add("spoolTime", this["spoolTime"]).
	data:add("throttle", this["throttle"]).
	data:add("ignitionStatus", this["ignitionStatus"]).
	data:add("throttleParam", this["throttleParam"]).
	data:add("throttleMode", this["throttleMode"]).
	
	data:add("ullageType", this["ullageType"]).
	data:add("ullageTime", this["ullageTime"]).
	
	data:add("rcsState", this["rcsState"]).
	
	return data.
}

function Stage_Arm
{
	parameter this.
	
	for e in this["engines"]
	{
		e:activate().
	}
}

function Stage_Ignition
{
	parameter this.
	
	this["setup"](this).
	set this["enabled"] to true.
	set this["throttle"] to 1.
}

function Stage_Shutdown
{
	parameter this.

	unlock throttle.
	set this["enabled"] to false.
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
		set this["ignitionStatus"] to "ullage".
		
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

// Calculates the weighted harmonic mean of the combined Isp.
function Stage_Isp
{
	parameter this.
	
	local sumThrust is 0.
	local sumMdot is 0.
	
	for e in this["engines"]
	{
		local isp is e:isp.
		local thrust is e:availablethrust.
		local mdot is thrust / isp.
		
		set sumThrust to sumThrust + thrust.
		set sumMdot to sumMdot + mdot.
	}
	
	return sumThrust / sumMdot.
}

// Calculates the total available thrust.
function Stage_Thrust
{
	parameter this.
	
	local sumthrust is 0.
	
	for e in this["engines"]
	{
		set sumThrust to sumThrust + e:availablethrust.
	}
	
	return sumthrust.
}

function Stage_Refresh
{
	parameter this.
	
	this["engines"]:clear().
	this["ullageMotor"]:clear().
	list engines in shipengines.
	for eng in shipengines
	{
		if eng:tag = this["stageInfo"]["tag"]
		{
			this["engines"]:add(eng).
		}
		if this["stageInfo"]["umTag"] <> ""
		{
			if eng:tag = this["stageInfo"]["umTag"]
			{
				this["ullageMotor"]:add(eng).
			}
		}
	}
}