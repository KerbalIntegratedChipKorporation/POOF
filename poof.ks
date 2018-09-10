// stdlib.ks
// Standard Library Selector

@lazyglobal off.

// Copies the provided version of the standard library to the provided directory.
function stdlib_GetLibrary
{
	local parameter namespace.
	
	copypath("0:/poof/reload.ksm", "1:/reload.ksm").
	
	local lastPath is path().
	
	local localPath is "1:/stdlib/".
	if exists(localPath)
	{
		deletepath(localPath).
	}
	
	switch to 1.
	createdir("stdlib").
	
	local stdlibPath is "0:/poof/" + namespace.
	
	if exists(stdlibPath)
	{
		_stdlib_CopyPath(stdlibPath, localPath).
	}
	else
	{
		return false.
	}
	
	cd(lastPath).
	return true.
}

function stdlib_AppendLibrary
{
	local parameter namespace.
	
	copypath("0:/poof/reload.ksm", "1:/reload.ksm").
	
	local lastPath is path().
	
	local localPath is "1:/stdlib/".
	
	local stdlibPath is "0:/poof/" + namespace.
	
	if exists(stdlibPath)
	{
		_stdlib_CopyPath(stdlibPath, localPath).
	}
	else
	{
		return false.
	}
	
	cd(lastPath).
	return true.
}

function _stdlib_CopyPath
{
	local parameter source.
	local parameter dest.
	
	local lastPath is path().
	
	if exists(source) = false
	{
		cd(lastPath).
		return false.
	}
	else
	{
		cd(source).
		local fileList is 0.
		list files in fileList.
		for f in fileList
		{
			copypath(source + "/" + f:name, dest).
		}
	}

	cd(lastPath).
	return true.
}

function Include
{
	local parameter filename.
	
	runoncepath("1:/stdlib/" + filename + ".ksm").
}
