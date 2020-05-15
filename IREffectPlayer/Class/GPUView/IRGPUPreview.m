//
//  IRGPUPreview.m
//  demo
//
//  Created by irons on 2019/11/8.
//  Copyright © 2019年 irons. All rights reserved.
//

#import "IRGPUPreview.h"

@implementation IRGPUPreview{
    __weak GPUImageFramebuffer* inputFramebuffer;
}

#pragma mark -
#pragma mark GPUInput protocol

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
{
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];
    
//    if(self.VCSessionFrameDelegate){
//        //        [inputFramebuffer lock];
//        [self.VCSessionFrameDelegate callback:[inputFramebuffer pixelBuffer] durr:50];
//        //        [inputFramebuffer unlock];
//    }
}

- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
{
    [super setInputFramebuffer:newInputFramebuffer atIndex:textureIndex];
    inputFramebuffer = newInputFramebuffer;
}

@end
