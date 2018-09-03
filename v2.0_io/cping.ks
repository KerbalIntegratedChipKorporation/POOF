// cping.ks
// Prints the current ID to the console
// This utilizes TIMER, IDGEN, and CONSOLE

Include("controller").
Include("timer").
Include("console").

function CPing_New
{
	local this is NewController(CPing_setup@, CPing_loop@, CPing_Err@).
	
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

function CPing_Ping
{
	parameter this.
	
	print random().
}
