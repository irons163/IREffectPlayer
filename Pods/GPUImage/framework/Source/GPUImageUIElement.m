#import "GPUImageUIElement.h"

@interface GPUImageUIElement ()
{
    UIView *view;
    CALayer *layer;
    
    CGSize previousLayerSizeInPixels;
    CMTime time;
    NSTimeInterval actualTimeOfLastUpdate;
}

@end

@implementation GPUImageUIElement

#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithView:(UIView *)inputView;
{
    if (!(self = [super init]))
    {
		return nil;
    }
    
    view = inputView;
    layer = inputView.layer;

    previousLayerSizeInPixels = CGSizeZero;
    [self update];
    
    return self;
}

- (id)initWithLayer:(CALayer *)inputLayer;
{
    if (!(self = [super init]))
    {
		return nil;
    }
    
    view = nil;
    layer = inputLayer;

    previousLayerSizeInPixels = CGSizeZero;
    [self update];

    return self;
}

#pragma mark -
#pragma mark Layer management

- (CGSize)layerSizeInPixels;
{
    CGSize pointSize = layer.bounds.size;
    return CGSizeMake(layer.contentsScale * pointSize.width, layer.contentsScale * pointSize.height);
}

- (void)update;
{
    [self updateWithTimestamp:kCMTimeIndefinite];
}

- (void)updateUsingCurrentTime;
{
    if(CMTIME_IS_INVALID(time)) {
        time = CMTimeMakeWithSeconds(0, 600);
        actualTimeOfLastUpdate = [NSDate timeIntervalSinceReferenceDate];
    } else {
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval diff = now - actualTimeOfLastUpdate;
        time = CMTimeAdd(time, CMTimeMakeWithSeconds(diff, 600));
        actualTimeOfLastUpdate = now;
    }

    [self updateWithTimestamp:time];
}

- (void)updateWithTimestamp:(CMTime)frameTime;
{
    [GPUImageContext useImageProcessingContext];
    
    CGSize layerPixelSize = [self layerSizeInPixels];
    
    if(CGSizeEqualToSize(layerPixelSize, CGSizeZero))
        return;
    
    @autoreleasepool {
        CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
        CGRect containerRect = [layer bounds];

        CVPixelBufferRef pixelBuffer = NULL;
        CVPixelBufferCreate(kCFAllocatorDefault, layerPixelSize.width, layerPixelSize.height, kCVPixelFormatType_32BGRA,NULL, &pixelBuffer);
        CVPixelBufferLockBaseAddress( pixelBuffer, 0 );
        
        //creating bitmap context
        CGContextRef imageContext = NULL;
        imageContext = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(pixelBuffer),
                                             CVPixelBufferGetWidth(pixelBuffer),
                                             CVPixelBufferGetHeight(pixelBuffer),
                                             8, CVPixelBufferGetBytesPerRow(pixelBuffer), genericRGBColorspace,
                                             kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst
                                             );
        
        CGContextTranslateCTM(imageContext, 0.0f, layerPixelSize.height);
        CGContextScaleCTM(imageContext, layer.contentsScale, -layer.contentsScale);
        
        void (^yourBlock)(void) = ^(void) {
            [layer renderInContext:imageContext];
        };
        
        yourBlock();
        
        // TODO: This may not work
        outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:layerPixelSize textureOptions:self.outputTextureOptions onlyTexture:YES];
        [outputFramebuffer disableReferenceCounting]; // Add this line, because GPUImageTwoInputFilter.m frametime updatedMovieFrameOppositeStillImage is YES, but the secondbuffer not lock
        
        glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
        // no need to use self.outputTextureOptions here, we always need these texture options
        //         glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, pixelBuffergetda);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(pixelBuffer));

        CGColorSpaceRelease(genericRGBColorspace);
        CGContextRelease(imageContext);
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        CVPixelBufferRelease(pixelBuffer);
    }
    
    for (id<GPUImageInput> currentTarget in targets)
    {
        if (currentTarget != self.targetToIgnoreForUpdates)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:layerPixelSize atIndex:textureIndexOfTarget];
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget]; // add this line, because the outputFramebuffer is update above
            [currentTarget newFrameReadyAtTime:frameTime atIndex:textureIndexOfTarget];
        }
    }
}

@end
