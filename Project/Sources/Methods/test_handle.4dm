//%attributes = {}
var $file : cs:C1710.File
$file:=cs:C1710.File.new(Folder:C1567(fk desktop folder:K87:19).file("testfilehndle"))
$file.delete()

var $handle : cs:C1710.FileHandle

////////////////////////
// test create
////////////////////////

$handle:=$file.open()  // will create
If (Asserted:C1132($handle#Null:C1517; "cannot open"))
	ON ERR CALL:C155("try")
	$handle.write("test")
	$handle.write("test")
	$handle.write("test")
	$handle.write("test")
	
	ON ERR CALL:C155("")
	$handle.close()  // must close
	
End if 

ASSERT:C1129($file.getText()="testtesttesttest")

////////////////////////
// test open
////////////////////////
$handle:=$file.open("w")  // will just open
If (Asserted:C1132($handle#Null:C1517; "cannot open"))
	ON ERR CALL:C155("try")
	$handle.write("test")
	$handle.write("test")
	$handle.write("test")
	$handle.write("test")
	
	ON ERR CALL:C155("")
	$handle.close()  // must close
	
End if 

ASSERT:C1129($file.getText()="testtesttesttest")  // nothing change


////////////////////////
// test apend
////////////////////////
$handle:=$file.open("a")  // will open to append
If (Asserted:C1132($handle#Null:C1517; "cannot open"))
	ON ERR CALL:C155("try")
	$handle.write("test")
	$handle.write("test")
	$handle.write("test")
	$handle.write("test")
	
	ON ERR CALL:C155("")
	$handle.close()  // must close
	
End if 

ASSERT:C1129($file.getText()="testtesttesttesttesttesttesttest")  // append

////////////////////////
// test double open
////////////////////////
$handle:=$file.open("a")  // will open to append
ASSERT:C1129($handle#Null:C1517)
ON ERR CALL:C155("try")
$handleAgain:=$file.open("")  //open again
ON ERR CALL:C155("")

ASSERT:C1129($handleAgain=Null:C1517; "must not open two times")
$handle.close()  // must close