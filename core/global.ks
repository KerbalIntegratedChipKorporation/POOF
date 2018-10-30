// global.ks
// Contains global configuration data

global EnableStdOut is true.
global EnableDebug is false.

when EnableDebug then
{
	Include("debug").
}

global STATIC_AUTOPILOT is lexicon().