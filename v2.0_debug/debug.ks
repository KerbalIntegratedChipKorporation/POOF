// debug.ks
// Handles debugging routines

function Debug_Dump
{
	parameter obj.
	
	writejson(obj, "1:/dump.json").
}

function Debug_Print
{
	parameter s.
	
	if EnableDebug
	{
		print s.
	}
}