//
//  IngEncodeM4a.m
//  Created by com.ingenious on 07/05/15



#import "IngEncodeM4a.h"


@implementation IngEncodeM4a

- (void)IngEncodeM4a:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* src = [command.arguments objectAtIndex:0];
    NSString* target = [command.arguments objectAtIndex:1];
      NSArray *temparray =[self ls];
    NSString* srcpath = [NSString stringWithFormat:@"%@/%@",documentdirectorytemp,src];
    NSString* targetpath = [NSString stringWithFormat:@"%@/%@",documentdirectorytemp,target];
    // check target file
    if (!target)
    {
        target = [[src stringByDeletingPathExtension] stringByAppendingPathExtension:@"m4a"];
    }
    
    // check if source file exists
    if (![[NSFileManager defaultManager] fileExistsAtPath:srcpath])
    {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Source file doesn't exist."];
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        return ;
    }
    else
    {
        NSURL* srcUrl = [NSURL fileURLWithPath:srcpath];
        AVURLAsset* audioAsset = [[AVURLAsset alloc] initWithURL:srcUrl options:nil];
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:audioAsset presetName:AVAssetExportPresetAppleM4A];
        session.outputURL = [NSURL fileURLWithPath:targetpath];
        session.outputFileType = AVFileTypeAppleM4A;
        
        [session exportAsynchronouslyWithCompletionHandler:^{
            CDVPluginResult* pluginResult = nil;
            
            if (session.status == AVAssetExportSessionStatusCompleted)
            {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            }
            else
            {
                NSString *msg = [session.error localizedDescription];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:msg];
            }
            
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }
}
- (NSArray *)ls {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentdirectorytemp =[paths objectAtIndex:0];
    NSArray *directoryContent = [[NSFileManager defaultManager] directoryContentsAtPath: documentsDirectory];
    
    
    
    NSLog(@"%@", documentsDirectory);
    return directoryContent;
}


@end
