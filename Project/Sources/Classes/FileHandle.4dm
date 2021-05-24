

Class constructor($docRef : Time)
	This:C1470.wrapped:=$docRef
	
Function wrappedTime()->$docRef:=Time  // 4d cannot store time, so cannot use This.wrapped
	$docRef:=Time:C179(This:C1470.wrapped)
	
Function setPosition($offset : Real; $anchor : Integer)
	If (Count parameters:C259>1)
		SET DOCUMENT POSITION:C482(Time:C179(This:C1470.wrapped); $offset; $anchor)
	Else 
		SET DOCUMENT POSITION:C482(Time:C179(This:C1470.wrapped); $offset)
	End if 
	
Function close()
	CLOSE DOCUMENT:C267(Time:C179(This:C1470.wrapped))  //Close the document
	
Function write($value : Variant)
	Case of 
		: (Value type:C1509($value)=Is text:K8:3)
			SEND PACKET:C103(Time:C179(This:C1470.wrapped); String:C10($value))
		: (Value type:C1509($value)=Is BLOB:K8:12)
			var $blob : Blob
			$blob:=$value
			SEND PACKET:C103(Time:C179(This:C1470.wrapped); $blob)
		: (Value type:C1509($value)=Is object:K8:27)
			SEND PACKET:C103(Time:C179(This:C1470.wrapped); JSON Stringify:C1217($value))
		: (Value type:C1509($value)=Is collection:K8:32)
			SEND PACKET:C103(Time:C179(This:C1470.wrapped); JSON Stringify:C1217($value))
		Else 
			SEND PACKET:C103(Time:C179(This:C1470.wrapped); String:C10($value))  // try in last resort, could work for number
	End case 