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
        
        
        AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:srcpath]];
        
        NSURL *exportURL = [NSURL fileURLWithPath:targetpath];
        
        // reader
        NSError *readerError = nil;
        AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset
                                                               error:&readerError];
        
        AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        AVAssetReaderTrackOutput *readerOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track
                                                                                  outputSettings:nil];
        [reader addOutput:readerOutput];
        
        // writer
        NSError *writerError = nil;
        AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:exportURL
                                                          fileType:AVFileTypeAppleM4A
                                                             error:&writerError];
        
        AudioChannelLayout channelLayout;
        memset(&channelLayout, 0, sizeof(AudioChannelLayout));
        channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
        
        // use different values to affect the downsampling/compression  //44100.0
        NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                        [NSNumber numberWithFloat:24000.0], AVSampleRateKey,
                                        [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                        [NSNumber numberWithInt:128000], AVEncoderBitRateKey,
                                        [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                        nil];
        
        AVAssetWriterInput *writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio
                                                                         outputSettings:outputSettings];
        [writerInput setExpectsMediaDataInRealTime:NO];
        [writer addInput:writerInput];
        
        //////////
        [writer startWriting];
        [writer startSessionAtSourceTime:kCMTimeZero];
        
        [reader startReading];
        dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
        [writerInput requestMediaDataWhenReadyOnQueue:mediaInputQueue usingBlock:^{
            
            NSLog(@"Asset Writer ready : %d", writerInput.readyForMoreMediaData);
            while (writerInput.readyForMoreMediaData) {
                CMSampleBufferRef nextBuffer;
                if ([reader status] == AVAssetReaderStatusReading && (nextBuffer = [readerOutput copyNextSampleBuffer])) {
                    if (nextBuffer) {
                        NSLog(@"Adding buffer");
                        [writerInput appendSampleBuffer:nextBuffer];
                    }
                } else {
                    [writerInput markAsFinished];
                     CDVPluginResult* pluginResult = nil;
                    switch ([reader status]) {
                        case AVAssetReaderStatusReading:
                            break;
                        case AVAssetReaderStatusFailed:
                            [writer cancelWriting];
                            break;
                        case AVAssetReaderStatusCompleted:
                            NSLog(@"Writer completed");
                            [writer endSessionAtSourceTime:asset.duration];
                            [writer finishWriting];
                            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                            //                     NSData *data = [NSData dataWithContentsOfFile:exportPath];
                            //                     NSLog(@"Data: %@", data);
                            
                            break;
                    }
                    break;
                }
            }
            
        }];
       
        
        /*NSURL* srcUrl = [NSURL fileURLWithPath:srcpath];
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
        }];*/
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
