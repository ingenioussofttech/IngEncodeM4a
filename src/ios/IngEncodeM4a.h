//
//  IngEncodeM4a.h
//  Created by com.ingenious on 07/05/15


#import <Cordova/CDVPlugin.h>
#import <AVFoundation/AVFoundation.h>


@interface IngEncodeM4a : CDVPlugin
{
    NSString *documentdirectorytemp;
}

- (void)IngEncodeM4a:(CDVInvokedUrlCommand*)command;

@end
