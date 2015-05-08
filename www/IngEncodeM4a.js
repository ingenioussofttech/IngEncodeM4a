var exec = require('cordova/exec');

/**
 * Convert the audio to m4a
 *
 * Usage: window.IngEncodeM4a(srcFileName, TargetFileName, successm4a,failm4a);
 */

               
               var IngEncodeM4a = function(source, target, success, fail) {
             
                    exec(success, fail, "IngEncodeM4a", "IngEncodeM4a", [source, target]);
               };
               
               module.exports = IngEncodeM4a;


