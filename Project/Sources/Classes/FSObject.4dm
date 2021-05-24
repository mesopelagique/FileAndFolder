
Class constructor($wrapped : Object)
	This:C1470.wrapped:=$wrapped
	
Function path()->$path : Text
	$path:=This:C1470.wrapped.path
	
Function showOnDisk()
	SHOW ON DISK:C922(This:C1470.wrapped.platformPath)
	
	