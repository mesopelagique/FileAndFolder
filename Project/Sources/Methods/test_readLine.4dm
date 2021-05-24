//%attributes = {}
var $file : cs:C1710.File
$file:=cs:C1710.File.new(Folder:C1567(fk desktop folder:K87:19).file("testread"))
$file.delete()

// write test file
$col:=New collection:C1472()
For ($i; 0; 100)
	$col.push(String:C10($i))
End for 

$file.setText($col.join("\r"))

// read file line by line, useful for big files
var $handle : cs:C1710.FileHandle

// using repeat and OK=0
$handle:=$file.open("r")
$colRes:=New collection:C1472()
var $line : Text
Repeat 
	$line:=$handle.readLine()
	$colRes.push($line)
Until (OK=0)
$handle.close()
ASSERT:C1129($colRes.equal($col))

// /!\ following code will failed with empty line, we cannot have Null Text
// so we cannot know really if finish reading
// so we must change code to get doc size and check current position and return a bool to see if at end
// or use OK var like before

$handle:=$file.open("r")

$colRes:=New collection:C1472()
var $line : Text
$line:=""
While (let(->$line; Formula:C1597($handle.readLine()); Formula:C1597(Length:C16($1)>0)))
	
	$colRes.push($line)
	
End while 

$handle.close()

ASSERT:C1129($colRes.equal($col))


// do without let
$handle:=$file.open("r")

$colRes:=New collection:C1472()
var $line : Text
$line:=$handle.readLine()
While (Length:C16($line)>0))
	
	$colRes.push($line)
	
	$line:=$handle.readLine()
End while 

$handle.close()

ASSERT:C1129($colRes.equal($col))


