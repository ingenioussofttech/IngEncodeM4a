## PhoneGap/Cordova AudioEncode Plugin
 * Original by Kavita Mevada (Ingenious Softtech)
 
## About this Plugin

This plugin lets you easily convert WAV audio into M4A audio. It is useful when using the Phonegap audio capture or media recording functionality. And recorded file stored at cdvfile location

## Using the Plugin


Example:

```
 window.IngEncodeM4a(srcFileName, TargetFileName, successm4a,failm4a);
srcFileName= Only name of Source file with extension example.wav
TargetFileName = Only name of Destination file with extension which want to new gene ate examplenew.m4a

file must be located at cdvfile://localhost/persistent/ or document://


var successm4a = function() {
    
    
    alert("success");
}

var failm4a = function(statusCode) {
   
    console.log(statusCode);
    alert("fail"+statusCode);
}

```

## Adding the Plugin ##

```
  cordova plugin add  ``` https://github.com/ingenioussofttech/IngEncodeM4a.git


