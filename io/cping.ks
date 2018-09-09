// cping.ks
// Prints the current ID to the console
// This utilizes TIMER, IDGEN, and CONSOLE

Include("controller").
Include("timer").
Include("console").

function CPing_New
{
	local this is NewController("cping", CPing_setup@, CPing_loop@, CPing_Err@, CPing_GetData@).
	
	this:add("timer", Timer_New(0.5, this, "ping")).
	this:add("ping", CPing_Ping@).
	
	return this.
}

function CPing_setup
{
	parameter this.
	
	this["timer"]["setup"](this).
	
	return 0.
}

function CPing_loop
{
	parameter this.
	
	this["timer"]["loop"](this["timer"]).
	
	return 0.
}

function CPing_Err
{
	parameter this.
	parameter errorCode.
	parameter caller.

	return 0.
}

// This function is intended to return telemetry data.
function CPing_GetData
{
	parameter this.
	
	local data is lexicon().
	
	// Add your data points here
	// data:add("key", value).
	
	return data.
}

function CPing_Ping
{
	parameter this.
	
	print random().
}
