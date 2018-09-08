// stageinfo.ks

function StageInfo
{
	parameter tag, umTag, spoolTime, hasClamps, ullageType, ullageTime, twr.
	
	return lexicon("tag", tag, "umTag", umTag, "spoolTime", spoolTime, "hasClamps", hasClamps, "ullageType", ullageType, "ullageTime", ullageTime, "twr", twr).
}