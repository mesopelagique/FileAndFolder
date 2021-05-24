# FileAndFolder

 Just proxy/adapter classes to 4D File and Folder

## Handle

Read files

### Read by line

```4d
var $handle : cs.FileHandle
$handle:=$file.open("r")
var $line : Text
Repeat 
    $line:=$handle.readLine()
Until (OK=0)
$handle.close()// do it always
```

### Write

```4d
var $handle : cs.FileHandle
$handle:=$file.open("w")
If (Asserted($handle#Null; "cannot open"))
	ON ERR CALL("try")
	$handle.write("test")
	$handle.write("test")
	
	ON ERR CALL("")
	$handle.close() // do it always
End if
```

#### Write At the end

```4d
var $handle : cs.FileHandle
$handle:=$file.open("a")
If (Asserted($handle#Null; "cannot open"))
	ON ERR CALL("try")
	$handle.write("test")
	$handle.write("test")
	
	ON ERR CALL("")
	$handle.close() // do it always
End if
```
