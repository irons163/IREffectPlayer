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
//    return CGSizeMake(layer.contentsScale * pointSize.width * 3.5, layer.contentsScale * pointSize.height / 4);
//    return CGSizeMake(layer.contentsScale * pointSize.width * (16.0/9.0), layer.contentsScale * pointSize.height * (9.0/16.0));
//    return CGSizeMake(layer.contentsScale * pointSize.width * ([UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width), layer.contentsScale * pointSize.height * ([UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height));
    return CGSizeMake(layer.contentsScale * pointSize.width * (1206/640.0), layer.contentsScale * pointSize.height * (640.0/1206));
//    return CGSizeMake(layer.contentsScale * pointSize.width * (640.0/336.0), layer.contentsScale * pointSize.height * (336.0/640.0));
//    return CGSizeMake(layer.contentsScale * pointSize.width / [[UIScreen mainScreen] scale], layer.contentsScale * pointSize.height / [[UIScreen mainScreen] scale]);
//    CGSize pointSize = layer.bounds.size;
//    return CGSizeMake(layer.contentsScale * pointSize.width, layer.contentsScale * pointSize.height);
//    return CGSizeMake((NSInteger)(layer.contentsScale * pointSize.width / [[UIScreen mainScreen] scale]) + 1, (NSInteger)(layer.contentsScale * pointSize.height / [[UIScreen mainScreen] scale]) + 1);
//    return CGSizeMake((NSInteger)(layer.contentsScale * pointSize.width / [[UIScreen mainScreen] scale]) + 1, (NSInteger)(layer.contentsScale * pointSize.height / [[UIScreen mainScreen] scale]));
//    return CGSizeMake(208, (NSInteger)(layer.contentsScale * pointSize.height / [[UIScreen mainScreen] scale]));
/*
    NSInteger width = layer.bounds.size.width;
    if (width % 2 != 0) {
        width += 1;
    }
    NSInteger height = layer.bounds.size.height;
    if (height % 2 != 0) {
        height += 1;
    }
    
    return CGSizeMake(width * [[UIScreen mainScreen] scale], height * [[UIScreen mainScreen] scale]);
 */
//    return CGSizeMake(828 + 4, 1334);
//    return CGSizeMake(414 + 2, 1334);
//    return CGSizeMake(384, 502);
//    return CGSizeMake(376, 640);
//    return CGSizeMake(368, 640);
//    return CGSizeMake(368, 667);
//    return CGSizeMake(750, 1334);
//    return CGSizeMake(750 + 2, 1334);
//    return CGSizeMake(752, 800);
//    return CGSizeMake(370, 670);
//    return CGSizeMake(208, 368);
//    return CGSizeMake(414 / 2, 736 / 2);
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
//    GLubyte *imageData = (GLubyte *) calloc(1, (int)layerPixelSize.width * (int)layerPixelSize.height * 4);
//
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef imageContext = CGBitmapContextCreate(imageData, (int)layerPixelSize.width, (int)layerPixelSize.height, 8, (int)layerPixelSize.width * 4, genericRGBColorspace,  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
////    CGContextRotateCTM(imageContext, M_PI_2);
//    CGContextTranslateCTM(imageContext, 0.0f, layerPixelSize.height);
//    CGContextScaleCTM(imageContext, layer.contentsScale, -layer.contentsScale);
//    //        CGContextSetBlendMode(imageContext, kCGBlendModeCopy); // From Technical Q&A QA1708: http://developer.apple.com/library/ios/#qa/qa1708/_index.html
////         [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    [layer renderInContext:imageContext];
//
//    CGContextRelease(imageContext);
//    CGColorSpaceRelease(genericRGBColorspace);
         

         
//         CGContextRelease(imageContext);
//         CGColorSpaceRelease(genericRGBColorspace);
         
//         UIImage* image = nil;
//
//         CGSize size = [layer bounds].size;
//
//         UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
         CGRect containerRect = [layer bounds];
//
//         BOOL ok = [view drawViewHierarchyInRect:containerRect afterScreenUpdates:YES];
//
//         if( ok )
//         {
//             image = UIGraphicsGetImageFromCurrentImageContext();
//         }else{
//             NSLog(@"drawViewHierarchyInRect failed");
//         }
//
//         UIGraphicsEndImageContext();
//
//         CGDataProviderRef provider = CGImageGetDataProvider(image.CGImage);
//         NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
//         GLubyte* imageData = (GLubyte*)[data bytes];
         
         
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
         
         
         //         CGContextScaleCTM(bitmapContext, _scale, _scale);
         //         CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, _viewSize.height);
         //         CGContextConcatCTM(bitmapContext, flipVertical);
//        CGContextTranslateCTM(imageContext, 0.0f, layerPixelSize.height);
//        CGContextScaleCTM(imageContext, layer.contentsScale, -layer.contentsScale);
         CGContextTranslateCTM(imageContext, 0.0f, 0);
//         CGContextScaleCTM(imageContext, layer.contentsScale, layer.contentsScale);
//         CGContextScaleCTM(imageContext, [UIScreen mainScreen].scale, 1);
         CGContextScaleCTM(imageContext, [UIScreen mainScreen].scale, [UIScreen mainScreen].scale);

         void (^yourBlock)(void) = ^(void) {
//             UIGraphicsPushContext(imageContext); {
//                 CGRect containerRect = [layer bounds];
////                 if ([NSThread isMainThread])
//                    BOOL ok = [view drawViewHierarchyInRect:containerRect afterScreenUpdates:NO];
//
//                 if( !ok )
//                  {
//                      NSLog(@"drawViewHierarchyInRect failed");
//                  }
////                 else
////                    [view drawViewHierarchyInRect:containerRect afterScreenUpdates:YES];
//             } UIGraphicsPopContext();
             
             [layer renderInContext:imageContext];
//             UIGraphicsPushContext(imageContext);
//             [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
         };
         
//         if ([NSThread isMainThread])
            yourBlock();
//         else
//            dispatch_async(dispatch_get_main_queue(), yourBlock);
         
         // TODO: This may not work
         outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:layerPixelSize textureOptions:self.outputTextureOptions onlyTexture:YES];
         [outputFramebuffer disableReferenceCounting]; // Add this line, because GPUImageTwoInputFilter.m frametime updatedMovieFrameOppositeStillImage is YES, but the secondbuffer not lock
         
         glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
         // no need to use self.outputTextureOptions here, we always need these texture options
//         glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, pixelBuffergetda);
         glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(pixelBuffer));
         
//         CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
         
//         CVOpenGLESTextureRef renderTexture;
//
//         CVOpenGLESTextureCacheCreateTextureFromImage (kCFAllocatorDefault, [[GPUImageContext sharedImageProcessingContext] coreVideoTextureCache], pixelBuffer,
//                                                       NULL, // texture attributes
//                                                       GL_TEXTURE_2D,
//                                                       GL_RGBA, // opengl format
//                                                       (int)layerPixelSize.width,
//                                                       (int)layerPixelSize.height,
//                                                       GL_BGRA, // native iOS format
//                                                       GL_UNSIGNED_BYTE,
//                                                       0,
//                                                       &renderTexture);
//
////         glBindTexture(CVOpenGLESTextureGetTarget(renderTexture), CVOpenGLESTextureGetName(renderTexture));
////         glBindTexture(GL_TEXTURE_2D, CVOpenGLESTextureGetName(renderTexture));
//         glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//         glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
////         glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(pixelBuffer));
////         glBindTexture(CVOpenGLESTextureGetTarget(renderTexture), CVOpenGLESTextureGetName(renderTexture));
////         glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, CVOpenGLESTextureGetName(renderTexture), 0);
//
//
////         CFRelease(luminanceTextureRef);
//
////         free(imageData);
         CGColorSpaceRelease(genericRGBColorspace);
         CGContextRelease(imageContext);
         CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
         CVPixelBufferRelease(pixelBuffer);
    
//    // TODO: This may not work
//    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:layerPixelSize textureOptions:self.outputTextureOptions onlyTexture:YES];
//    [outputFramebuffer disableReferenceCounting]; // Add this line, because GPUImageTwoInputFilter.m frametime updatedMovieFrameOppositeStillImage is YES, but the secondbuffer not lock
//
//    glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
//    // no need to use self.outputTextureOptions here, we always need these texture options
//    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)layerPixelSize.width, (int)layerPixelSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, imageData);
//
//    free(imageData);
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
