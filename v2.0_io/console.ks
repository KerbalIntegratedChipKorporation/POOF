// console.ks
// Handles console I/O

function Console_Print
{
	parameter s.
	
	if EnableStdOut
	{
		print s.
	}
}