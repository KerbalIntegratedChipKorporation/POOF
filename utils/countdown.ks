// countdown.ks

Include("controller").
Include("timer").
Include("console").

function Countdown_New
{
	// Add parameters here
	// parameter x.
	parameter countdownLength.
	parameter callbackCtrl.
	parameter callbackFunc.
	parameter alertTimes.
	
	parameter this is NewController("countdown", Countdown_setup@, Countdown_loop@, Countdown_Err@).

	this:add("callbackCtrl", callbackCtrl).
	this:add("callbackFunc", callbackFunc).
	this:add("timer", Timer_New(1.0, this, "TimerElapsed", true)).
	this:add("countdown", countdownLength).
	this:add("alertTimes", alertTimes).
	this:add("timerelapsed", Countdown_TimerElapsed@).
	
	this:add("hold", Countdown_Hold@).
	this:add("resume", Countdown_Resume@).
	this:add("running", true).
	
	return this.
}

// The setup function is called when the controller is added
// to the executive program, or when the controller has been
// started. This may also be called by the parent, if it is
// not attached to an executive program.
function Countdown_setup
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	this["timer"]["setup"](this["timer"]).
	Countdown_Resume(this).
	
	return 0.
}

// The loop function is called when the controller's parent
// is going through its loop process and the controller is enabled.
function Countdown_loop
{
	// DO NOT ADD ADDITIONAL PARAMETERS!
	parameter this.
	
	if this["timer"]["enabled"]
	{
		this["timer"]["loop"](this["timer"]).
	}
	
	return 0.
}

function Countdown_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.
	
	// Do your error handling here
	
	return 0.
}

function Countdown_TimerElapsed
{
	parameter this.
	
	set this["countdown"] to this["countdown"] - 1.
	
	local t is (time - time) + this["countdown"].
	local minute is t:minute:tostring().
	local second is t:second:tostring().
	
	if t:second < 10
	{
		set second to "0" + second.
	}
		
	clearscreen.
	Console_print("T-" + minute + ":" + second).
	
	if this["alertTimes"]:contains(this["countdown"])
	{
		this["callbackCtrl"][this["callbackFunc"]](this["callbackCtrl"]).
	}
	
	if this["countdown"] = 0
	{
		this:clear().
	}
}

function Countdown_Hold
{
	parameter this.
	
	set this["timer"]["enabled"] to false.
	set this["running"] to false.
}

function Countdown_Resume
{
	parameter this.
	
	set this["timer"]["enabled"] to true.
	set this["running"] to true.
}