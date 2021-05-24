Class extends FSObject

Class constructor($wrapped : 4D:C1709.File)
	Super:C1705($wrapped)
	
Function delete()
	This:C1470.wrapped.delete()
	
Function getContent()->$blob : Blob
	$blob:=This:C1470.wrapped.getContent()
	
Function getText()->$text : Text
	$text:=This:C1470.wrapped.getText()
	
Function getObject()->$object : Object
	$object:=JSON Parse:C1218(This:C1470.wrapped.getText())
	
Function setObject($object : Object; $prettify : Boolean)
	Case of 
		: (Count parameters:C259<2)
			$object:=This:C1470.wrapped.setText(JSON Stringify:C1217($object))
		Else 
			If ($prettify)
				$object:=This:C1470.wrapped.setText(JSON Stringify:C1217($object; *))
			Else 
				$object:=This:C1470.wrapped.setText(JSON Stringify:C1217($object))
			End if 
	End case 
	
Function open($mode : Text)->$handle : cs:C1710.FileHandle
	var $modeSafe : Text
	If (Count parameters:C259>0)
		$modeSafe:=$mode
	Else 
		$modeSafe:=""
	End if 
	var $vhDoc : Time  //doc ref
	
	If (This:C1470.wrapped.exists)
		Case of 
			: (Position:C15("a"; $modeSafe)>0)
				$vhDoc:=Append document:C265(This:C1470.wrapped.platformPath)
			: ((Position:C15("r"; $modeSafe)>0) & (Position:C15("w"; $modeSafe)>0))
				$vhDoc:=Open document:C264(This:C1470.wrapped.platformPath; Read and write:K24:3)
			: (Position:C15("r"; $modeSafe)>0)
				$vhDoc:=Open document:C264(This:C1470.wrapped.platformPath; Read mode:K24:5)
			Else 
				$vhDoc:=Open document:C264(This:C1470.wrapped.platformPath; Write mode:K24:4)  // write mode if empty and not correct
		End case 
	Else 
		$vhDoc:=Create document:C266(This:C1470.wrapped.platformPath)
	End if 
	
	If ($vhDoc=0)
		$handle:=Null:C1517
	Else 
		$handle:=cs:C1710.FileHandle.new($vhDoc)
	End if 
	
Function encryptInPlace($passPhrase : Text; $salt : Integer)->$result : Boolean
	$result:=This:C1470.encryptTo($passPhrase; $salt; This:C1470.wrapped)
	
Function encryptTo($passPhrase : Text; $salt : Integer; $encryptedFile : 4D:C1709.File)->$result : Boolean
	var $fileContent; $blobToEncrypt; $blobEncrypted : Blob
	var $contentLength; $offset : Integer
	$fileContent:=$origiThis.wrapped.getContent()
	// Store original file length at the beginning of the blob to encrypt
	$contentLength:=BLOB size:C605($fileContent)
	VARIABLE TO BLOB:C532($contentLength; $blobToEncrypt; $offset)
	COPY BLOB:C558($fileContent; $blobToEncrypt; 0; $offset; $contentLength)
	$result:=Encrypt data BLOB:C1773($blobToEncrypt; $passPhrase; $salt; $blobEncrypted)
	If ($result)
		$encryptedFile.setContent($blobEncrypted)
	End if 
	
	//decryptFile
	
Function decryptFileTo($passPhrase : Text; $salt : Integer; $decryptedFile : 4D:C1709.File)->$result : Boolean
	// AES-type decryption : as encrypted blob size is a multiple of 16 bytes, some final null bytes may have been added.
	var $fileContent; $blobToDecrypt; $blobDecrypted : Blob
	var $contentLength; $offset : Integer
	$blobToDecrypt:=$encryptedFile.getContent()
	$result:=Decrypt data BLOB:C1774($blobToDecrypt; $passPhrase; $salt; $blobDecrypted)
	If ($result)
		// Retrieve original file length at the beginning of the decrypted blob
		BLOB TO VARIABLE:C533($blobDecrypted; $contentLength; $offset)
		COPY BLOB:C558($blobDecrypted; $fileContent; $offset; 0; $contentLength)
		$decryptedFile.setContent($fileContent)
	End if 
	
Function decryptFileInPlace($passPhrase : Text; $salt : Integer)->$result : Boolean
	$result:=This:C1470.decryptFileTo($passPhrase; $salt; This:C1470.wrapped)
	