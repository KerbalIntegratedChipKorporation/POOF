// build.ks

function Build_Namespace
{
	parameter namespace.

	local lastpath is path().
	local inputPath is "0:/poof/" + namespace + "/".
	local outputPath is "0:/poof/bin/" + namespace + "/".
	cd(inputPath).

	list files in filelist.
	
	for f in filelist
	{
		if f:extension = "ks"
		{
			print "Compiling " + f:name + "...".
			compile f to outputPath + f:name + "m".
		}
	}
	
	cd(lastpath).
}

Build_Namespace("core").
Build_Namespace("debug").
Build_Namespace("experimental").
Build_Namespace("guidance").
Build_Namespace("io").
Build_Namespace("utils").

print "Compiling poof...".
compile poof to "0:/poof/bin/poof.ksm".
print "Compiling reload...".
compile reload to "0:/poof/bin/reload.ksm".