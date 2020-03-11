//
//  IROutput.m
//  demo
//
//  Created by irons on 2020/2/10.
//  Copyright © 2020 irons. All rights reserved.
//

#import "IROutput.h"

@implementation IROutput

-(void) setOutputFramebuffer:(GPUImageFramebuffer *)outputFramebuffer{
    self->outputFramebuffer = outputFramebuffer;
}

- (void)processProgram
{
    runSynchronouslyOnVideoProcessingQueue(^{
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger targetTextureIndex = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:self.viewprotRange.size atIndex:targetTextureIndex];
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:targetTextureIndex];
            [currentTarget newFrameReadyAtTime:kCMTimeInvalid atIndex:targetTextureIndex];
        }
    });
}

- (void)processProgramWithTimestamp:(CMTime)frameTime
{
    runSynchronouslyOnVideoProcessingQueue(^{
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger targetTextureIndex = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:self.viewprotRange.size atIndex:targetTextureIndex];
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:targetTextureIndex];
            [currentTarget newFrameReadyAtTime:frameTime atIndex:targetTextureIndex];
        }
    });
}

@end
