//
//  IRGPU.m
//  demo
//
//  Created by irons on 2020/2/7.
//  Copyright © 2020年 irons. All rights reserved.
//

#import "IRGPU.h"
#import <objc/runtime.h>
#import <FLAnimatedImageView.h>
#import <FLAnimatedImage.h>
#import "GPUImageCropFilter.h"
#import "GPUImageAlphaBlendFilter.h"

@implementation IRGLView(AA)

static GLfloat imageVertices[8];

static void *displayProgramKey = &displayProgramKey;
static void *displayPositionAttributeKey = &displayPositionAttributeKey;
static void *displayTextureCoordinateAttributeKey = &displayTextureCoordinateAttributeKey;
static void *displayInputTextureUniformKey = &displayInputTextureUniformKey;
static void *displayRenderbufferKey = &displayRenderbufferKey;
static void *displayFramebufferKey = &displayFramebufferKey;
static void *boundsSizeAtFrameBufferEpochKey = &boundsSizeAtFrameBufferEpochKey;
static void *inputImageSizeKey = &inputImageSizeKey;
static void *inputFramebufferForDisplayKey = &inputFramebufferForDisplayKey;
static void *inputRotationKey = &inputRotationKey;
static void *irOutputKey = &irOutputKey;
static void *uiElementInputKey = &uiElementInputKey;
static void *filterKey = &filterKey;
static void *myfilterKey = &myfilterKey;
static void *cropFilterKey = &cropFilterKey;

static void *VCSessionFrameDelegateKey = &VCSessionFrameDelegateKey;
static void *tempKey = &tempKey;
static void *outputKey = &outputKey;
static void *enabledKey = &enabledKey;
static void *scissorRectKey = &scissorRectKey;

+ (void)swizzelWithDefaultSelector:(SEL)defaultSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = [self class];
    Method defaultMethod = class_getInstanceMethod(class, defaultSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL isMethodExists = !class_addMethod(class, defaultSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (isMethodExists) {
        method_exchangeImplementations(defaultMethod, swizzledMethod);
    }
    else {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(defaultMethod), method_getTypeEncoding(defaultMethod));
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL defaultSelector = @selector(render:);
        SEL swizzledSelector = @selector(swizzled_render:);
        
        [self swizzelWithDefaultSelector:defaultSelector swizzledSelector:swizzledSelector];
    });
}

#pragma mark - Method Swizzling
- (void)swizzled_render:(IRFFVideoFrame *)frame {
    if (CGSizeEqualToSize(CGSizeZero, [self.irOutput viewprotRange].size)) {
        return;
    }
    
    GPUImageFramebuffer *outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:[self.irOutput viewprotRange].size onlyTexture:NO];
    [self.irOutput setOutputFramebuffer:outputFramebuffer];
    [outputFramebuffer activateFramebuffer];
    
    [self swizzled_render:frame];
    
    [self.irOutput processProgram];
    
    NSLog(@"Render: %@",frame);
}

- (void)setup {
    self.irOutput = [[IROutput alloc] init];
    [self commonInit];
}

//- (void)setRenderModes:(NSArray<IRGLRenderMode *> *)modes {
- (void)updateSize {
    GLint           _width;
    GLint           _height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_height);
    self.irOutput.viewprotRange = CGRectMake(0, 0, _width, _height);
    
    
    if (self.temp) {
        [self.temp setFrame:self.irOutput.viewprotRange];
        return;
    }
    
    NSDate *startTime = [NSDate date];
    
    self.temp = [[WorkView alloc] initWithFrame:self.irOutput.viewprotRange];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 150.0f, 40.0f)];
    timeLabel.font = [UIFont systemFontOfSize:17.0f];
    timeLabel.text = @"Time: 0.0 s";
    timeLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    [timeLabel sizeToFit];
    //        [timeLabel setHidden:YES];
    [self.temp addSubview:timeLabel];
    
    self.cropFilter = [[GPUImageCropFilter alloc] init];
    self.cropFilter.cropRegion = CGRectMake(0, 0, 0.5f, 0.5f);
    [self.cropFilter setInputRotation:kGPUImageNoRotation atIndex:0];
    //    [cropFilter forceProcessingAtSizeRespectingAspectRatio:previewFrame.size];
    //        [cropFilter addTarget:i];
    
    //    [cropFilter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime) {
    //         runSynchronouslyOnVideoProcessingQueue(^{
    //        [[filter framebufferForOutput] lock];
    //        [((id<VCSessionFrameDelegate>)session) callback:[[filter framebufferForOutput] pixelBuffer] durr:50];
    //        [[filter framebufferForOutput] unlock];
    //             });
    //    }];
    
    self.myfilter = [[GPUImageFilter alloc] init];
    self.filter = [[GPUImageFilter alloc] init];
    GPUImageAlphaBlendFilter *blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    blendFilter.mix = 1.0;
    
    
    
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:CGRectMake(100.0, 100.0, 40.0f, 40.0f)];
    imageView.image = [UIImage imageNamed:@"Icon"];
    imageView.backgroundColor = [UIColor clearColor];
    [self.temp addSubview:imageView];
    
    //        UIWebView *webView= [[UIWebView alloc] initWithFrame:CGRectMake(200.0, 200.0, 240.0f, 100.0f)];
    ////        webView.image = [UIImage imageNamed:@"Icon"];
    //
    //        NSString * welcomeGifFileStr;
    //        if([[UIScreen mainScreen] bounds].size.height == 480){ //4s
    //            welcomeGifFileStr = @"Jerry Chen_20171120_174247_1";
    //        }else
    //            welcomeGifFileStr = @"Jerry Chen_20171120_174247_1";
    
    //        self.webViewToDisplayGIF.scrollView.scrollEnabled = NO;
    //        self.webViewToDisplayGIF.scrollView.bounces = NO;
    
    //        NSData *data = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:welcomeGifFileStr ofType:@"gif"]];
    //        [webView loadData:data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    //        webView.scalesPageToFit = YES;
    //        [webView setOpaque:NO];
    
    //**************** Add Static loading image to prevent white "flash" ****************/
    //        UIImage *loadingImage = [UIImage imageNamed:welcomeGifFileStr];
    //        UIImageView *loadingImageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //        loadingImageView.image = loadingImage;
    //        [webView insertSubview:loadingImageView atIndex:0];
    
    //        webView.backgroundColor = [UIColor clearColor];
    //        [temp addSubview:webView];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] init];
    gifImageView.frame                = CGRectMake(200.0, 50.0, 80.0f, 160.0f);
    NSData   *gifImageData             = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"Jerry Chen_20171120_174247_1"] ofType:@"gif" inDirectory:nil]];
    FLAnimatedImage* animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifImageData];
    [gifImageView setAnimatedImage:animatedImage];
    gifImageView.backgroundColor = [UIColor clearColor];
    //            [self addSubview:gifImageView];
    [self.temp addSubview:gifImageView];
    //            [self addSubview:temp];
    //            temp.hidden = YES;
    //            [gifImageView animationRepeatCount];
    [gifImageView startAnimating];
    //        });
    
    
    // Set up FLAnimatedImage logging.
    //        [FLAnimatedImage setLogBlock:^(NSString *logString, FLLogLevel logLevel) {
    //            // Using NSLog
    //            NSLog(@"%@", logString);
    //
    //            // ...or CocoaLumberjackLogger only logging warnings and errors
    //            if (logLevel == FLLogLevelError) {
    //                NSLog(@"%@", logString);
    //            } else if (logLevel == FLLogLevelWarn) {
    //                NSLog(@"%@", logString);
    //            }
    //        } logLevel:FLLogLevelWarn];
    
    FLAnimatedImageView *gifImageView2 = [[FLAnimatedImageView alloc] init];
    gifImageView2.frame                = CGRectMake(200.0, 50.0, 80.0f, 20.0f);
    gifImageData             = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"loading_blue"] ofType:@"gif" inDirectory:nil]];
    animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifImageData];
    [gifImageView2 setAnimatedImage:animatedImage];
    gifImageView2.backgroundColor = [UIColor clearColor];
    [self.temp addSubview:gifImageView2];
    [gifImageView2 startAnimating];
    
    self.uiElementInput = [[GPUImageUIElement alloc] initWithView:self.temp];
    [self.filter addTarget:blendFilter atTextureLocation:0];
    //        [filter addTarget:self];
    [self.uiElementInput addTarget:blendFilter atTextureLocation:1];
    
    [blendFilter addTarget:self];
    
    self.myfilter = blendFilter;
    
    __unsafe_unretained GPUImageUIElement *weakUIElementInput = self.uiElementInput;
    
    [self.filter setFrameProcessingCompletionBlock:^(GPUImageOutput * filter, CMTime frameTime){
//        timeLabel.text = [NSString stringWithFormat:@"Time: %f s", -[startTime timeIntervalSinceNow]];
//        [timeLabel sizeToFit];
        
//        // 与上一帧的间隔
//        NSTimeInterval interval = 0;
//        //            if (CMTIME_IS_VALID(_lastTime)) {
//        //                interval = CMTimeGetSeconds(CMTimeSubtract(_currentTime, _lastTime));
//        //            }
//        _currentTime = [[NSDate date] timeIntervalSince1970];
//        if(_lastTime != 0){
//            interval = _currentTime - _lastTime;
//        }
//        _lastTime = _currentTime;
        
        NSTimeInterval interval = 0;
        
        [gifImageView nextFrameIndexForInterval:interval];
        [gifImageView2 nextFrameIndexForInterval:interval];
        [weakUIElementInput update];
    }];
    
    
    
    [self.filter addTarget:self.cropFilter];
    
    [self.filter setInputRotation:kGPUImageNoRotation atIndex:0];
    [self.irOutput addTarget:self.filter];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    GLint           _width;
//    GLint           _height;
//    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_width);
//    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_height);
//    irOutput.viewprotRange = CGRectMake(0, 0, _width, _height);
//}

//- (void)render:(IRFFVideoFrame *)frame {
////    [GPUImageContext useImageProcessingContext];
////
//
//
//    [super render:frame];
//
//
//}

- (void)commonInit;
{
    // Set scaling to account for Retina display
    if ([self respondsToSelector:@selector(setContentScaleFactor:)])
    {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
    }
    
    self.inputRotation = kGPUImageNoRotation;
    
    self.enabled = YES;
    
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext useImageProcessingContext];
        
        self.displayProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImagePassthroughFragmentShaderString];
        if (!self.displayProgram.initialized)
        {
            [self.displayProgram addAttribute:@"position"];
            [self.displayProgram addAttribute:@"inputTextureCoordinate"];
            
            if (![self.displayProgram link])
            {
                NSString *progLog = [self.displayProgram programLog];
                NSLog(@"Program link log: %@", progLog);
                NSString *fragLog = [self.displayProgram fragmentShaderLog];
                NSLog(@"Fragment shader compile log: %@", fragLog);
                NSString *vertLog = [self.displayProgram vertexShaderLog];
                NSLog(@"Vertex shader compile log: %@", vertLog);
                self.displayProgram = nil;
                NSAssert(NO, @"Filter shader link failed");
            }
        }
        
        self.displayPositionAttribute = [self.displayProgram attributeIndex:@"position"];
        self.displayTextureCoordinateAttribute = [self.displayProgram attributeIndex:@"inputTextureCoordinate"];
        self.displayInputTextureUniform = [self.displayProgram uniformIndex:@"inputImageTexture"]; // This does assume a name of "inputTexture" for the fragment shader
        
        [GPUImageContext setActiveShaderProgram:self.displayProgram];
        glEnableVertexAttribArray(self.displayPositionAttribute);
        glEnableVertexAttribArray(self.displayTextureCoordinateAttribute);
        
        //        recalculateViewGeometry
        imageVertices[0] = -1;
        imageVertices[1] = -1;
        imageVertices[2] = 1;
        imageVertices[3] = -1;
        imageVertices[4] = -1;
        imageVertices[5] = 1;
        imageVertices[6] = 1;
        imageVertices[7] = 1;
    });
}


-(void)updateStickViews:(NSArray<StickerView *> *)stickViews{
    
    NSMutableArray* views = [NSMutableArray array];
    int i = 0;
    
    for(UIView *view in [self.temp subviews]){
        if(i >= 3)
            break;
        [views addObject:view];
        i++;
    }
    for(UIView *view in [self.temp subviews]){
        [view removeFromSuperview];
    }
    for(UIView *view in views){
        [self.temp addSubview:view];
    }
    for(UIView *view in stickViews){
        [self.temp addSubview:view];
    }
    
}



//-(void) doSnapShot
//{
//    willDoSnapshot = YES;
//}
//
//-(void) saveSnapShot{
//    if(willDoSnapshot){
//        [self saveSnapshotAlbum:[self createImageFromFramebuffer]];
//        willDoSnapshot = NO;
//    }
//}

#pragma mark GPUInput protocol

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
{
    //    dispatch_sync(queue, ^{
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext setActiveShaderProgram:self.displayProgram];
        
        [self setCurrentContext];
        
        [self clearCurrentBuffer];
        
        
        
        if(!CGRectEqualToRect(self.scissorRect, CGRectZero)){
            glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);
        }
        
        glActiveTexture(GL_TEXTURE7);
        glBindTexture(GL_TEXTURE_2D, [self.inputFramebufferForDisplay texture]);
        glUniform1i(self.displayInputTextureUniform, 7);
        
        glVertexAttribPointer(self.displayPositionAttribute, 2, GL_FLOAT, 0, 0, imageVertices);
        glVertexAttribPointer(self.displayTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, [IRGLView textureCoordinatesForRotation:self.inputRotation]);
        
        if(!CGRectEqualToRect(self.scissorRect, CGRectZero)){
            //            glEnable(GL_SCISSOR_TEST);
            //            glScissor(self.scissorRect.origin.x, self.scissorRect.origin.y, self.scissorRect.size.width, self.scissorRect.size.height);
        }
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        
        
        glFinish();
        
        
        [self bindCurrentRenderBuffer];
        [self presentRenderBuffer];
        
        
        
        [self.inputFramebufferForDisplay unlock];
        self.inputFramebufferForDisplay = nil;
        
        //        [self saveSnapShot];
    });
    //    });
}

- (NSInteger)nextAvailableTextureIndex;
{
    return 0;
}

- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
{
    self.inputFramebufferForDisplay = newInputFramebuffer;
    [self.inputFramebufferForDisplay lock];
}

- (void)setInputRotation:(GPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
{
    self.inputRotation = newInputRotation;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
{
    runSynchronouslyOnVideoProcessingQueue(^{
        CGSize rotatedSize = newSize;
        
        if (GPUImageRotationSwapsWidthAndHeight(self.inputRotation))
        {
            rotatedSize.width = newSize.height;
            rotatedSize.height = newSize.width;
        }
        
        if (!CGSizeEqualToSize(self.inputImageSize, rotatedSize))
        {
            self.inputImageSize = rotatedSize;
            //            [self recalculateViewGeometry];
        }
    });
}

- (CGSize)maximumOutputSize;
{
    if ([self respondsToSelector:@selector(setContentScaleFactor:)])
    {
        CGSize pointSize = self.bounds.size;
        return CGSizeMake(self.contentScaleFactor * pointSize.width, self.contentScaleFactor * pointSize.height);
    }
    else
    {
        return self.bounds.size;
    }
}

- (void)endProcessing
{
}

- (BOOL)shouldIgnoreUpdatesToThisTarget;
{
    return NO;
}

- (BOOL)wantsMonochromeInput;
{
    return NO;
}

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
{
    
}

-(void)doTarget{
    //       GPURawData* data = ;
    //        GPUImageRawDataInput *rawDataInput = [[GPUImageRawDataInput alloc] initWithBytes:(GLubyte*)CVPixelBufferGetBaseAddress(pixelBufferRef) size:CGSizeMake(10.0, 10.0)];
    //    //    GPUImageFilter *customFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CalculationShader"];
    //
    //
    //        GPUImageRawDataOutput *rawDataOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(10.0, 10.0) resultsInBGRAFormat:YES];
    //    //    [rawDataInput addTarget:customFilter];
    //    //    [customFilter addTarget:rawDataOutput]
    //        [rawDataInput addTarget:rawDataOutput];
    
    //    GPUImageTextureInput* textureInput = [[GPUImageTextureInput alloc] initWithTexture:<#(GLuint)#> size:<#(CGSize)#>];
    
}

+ (const GLfloat *)textureCoordinatesForRotation:(GPUImageRotationMode)rotationMode;
{
    //    static const GLfloat noRotationTextureCoordinates[] = {
    //        0.0f, 0.0f,
    //        1.0f, 0.0f,
    //        0.0f, 1.0f,
    //        1.0f, 1.0f,
    //    };
    
    static const GLfloat noRotationTextureCoordinates[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 0.0f,
    };
    
    static const GLfloat rotateRightTextureCoordinates[] = {
        1.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotateLeftTextureCoordinates[] = {
        0.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat verticalFlipTextureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    static const GLfloat horizontalFlipTextureCoordinates[] = {
        1.0f, 1.0f,
        0.0f, 1.0f,
        1.0f, 0.0f,
        0.0f, 0.0f,
    };
    
    static const GLfloat rotateRightVerticalFlipTextureCoordinates[] = {
        1.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 0.0f,
        0.0f, 1.0f,
    };
    
    static const GLfloat rotateRightHorizontalFlipTextureCoordinates[] = {
        0.0f, 1.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        1.0f, 0.0f,
    };
    
    static const GLfloat rotate180TextureCoordinates[] = {
        1.0f, 0.0f,
        0.0f, 0.0f,
        1.0f, 1.0f,
        0.0f, 1.0f,
    };
    
    switch(rotationMode)
    {
        case kGPUImageNoRotation: return noRotationTextureCoordinates;
        case kGPUImageRotateLeft: return rotateLeftTextureCoordinates;
        case kGPUImageRotateRight: return rotateRightTextureCoordinates;
        case kGPUImageFlipVertical: return verticalFlipTextureCoordinates;
        case kGPUImageFlipHorizonal: return horizontalFlipTextureCoordinates;
        case kGPUImageRotateRightFlipVertical: return rotateRightVerticalFlipTextureCoordinates;
        case kGPUImageRotateRightFlipHorizontal: return rotateRightHorizontalFlipTextureCoordinates;
        case kGPUImageRotate180: return rotate180TextureCoordinates;
    }
}



- (void)setDisplayProgram:(GLProgram *)displayProgram {
    objc_setAssociatedObject(self, &displayProgramKey, displayProgram, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GLProgram *)displayProgram {
    return objc_getAssociatedObject(self, &displayProgramKey);
}

- (void)setDisplayPositionAttribute:(GLint)displayPositionAttribute {
    objc_setAssociatedObject(self, &displayPositionAttributeKey, @(displayPositionAttribute), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GLint)displayPositionAttribute {
    return [objc_getAssociatedObject(self, &displayPositionAttributeKey) intValue];
}

- (void)setDisplayTextureCoordinateAttribute:(GLint)displayTextureCoordinateAttribute {
    objc_setAssociatedObject(self, &displayTextureCoordinateAttributeKey, @(displayTextureCoordinateAttribute), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GLint)displayTextureCoordinateAttribute {
    return [objc_getAssociatedObject(self, &displayTextureCoordinateAttributeKey) intValue];
}

- (void)setDisplayInputTextureUniform:(GLint)displayInputTextureUniform {
    objc_setAssociatedObject(self, &displayInputTextureUniformKey, @(displayInputTextureUniform), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GLint)displayInputTextureUniform {
    return [objc_getAssociatedObject(self, &displayInputTextureUniformKey) intValue];
}

- (void)setDisplayRenderbuffer:(GLuint)displayRenderbuffer {
    objc_setAssociatedObject(self, &displayRenderbufferKey, @(displayRenderbuffer), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GLuint)displayRenderbuffer {
    return [objc_getAssociatedObject(self, &displayRenderbufferKey) unsignedIntValue];
}

- (void)setDisplayFramebuffer:(GLuint)displayFramebuffer {
    objc_setAssociatedObject(self, &displayFramebufferKey, @(displayFramebuffer), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GLuint)displayFramebuffer {
    return [objc_getAssociatedObject(self, &displayFramebufferKey) unsignedIntValue];
}

- (void)setBoundsSizeAtFrameBufferEpoch:(CGSize)boundsSizeAtFrameBufferEpoch {
    objc_setAssociatedObject(self, &boundsSizeAtFrameBufferEpochKey, @(boundsSizeAtFrameBufferEpoch), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)boundsSizeAtFrameBufferEpoch {
    return [objc_getAssociatedObject(self, &boundsSizeAtFrameBufferEpochKey) CGSizeValue];
}

- (void)setInputImageSize:(CGSize)inputImageSize {
    objc_setAssociatedObject(self, &inputImageSizeKey, @(inputImageSize), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)inputImageSize {
    return [objc_getAssociatedObject(self, &inputImageSizeKey) CGSizeValue];
}

- (void)setInputFramebufferForDisplay:(GPUImageFramebuffer *)inputFramebufferForDisplay {
    objc_setAssociatedObject(self, &inputFramebufferForDisplayKey, inputFramebufferForDisplay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GPUImageFramebuffer *)inputFramebufferForDisplay {
    return objc_getAssociatedObject(self, &inputFramebufferForDisplayKey);
}

- (void)setInputRotation:(GPUImageRotationMode)inputRotation {
    objc_setAssociatedObject(self, &inputRotationKey, @(inputRotation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GPUImageRotationMode)inputRotation {
    return [objc_getAssociatedObject(self, &inputRotationKey) unsignedIntegerValue  ];
}

- (IROutput *)irOutput {
    return objc_getAssociatedObject(self, &irOutputKey);
}

- (void)setIrOutput:(IROutput *)irOutput {
    objc_setAssociatedObject(self, &irOutputKey, irOutput, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GPUImageUIElement *)uiElementInput {
    return objc_getAssociatedObject(self, &uiElementInputKey);
}

-(void)setUiElementInput:(GPUImageUIElement *)uiElementInput {
    objc_setAssociatedObject(self, &uiElementInputKey, uiElementInput, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GPUImageFilter *)filter {
    return objc_getAssociatedObject(self, &filterKey);
}

-(void)setFilter:(GPUImageOutput<GPUImageInput>*)filter{
    objc_setAssociatedObject(self, &filterKey, filter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(filter){
        //        NSArray* targets = [myfilter targets];
        //        [myfilter removeAllTargets];
        
        //        for(id<GPUImageInput> target in targets){
        //            [filter addTarget:target];
        //        }
        //        [filter addTarget:self];
        //        [myfilter removeTarget:cropFilter];
        [self.myfilter removeAllTargets];
        [self.myfilter addTarget:filter];
        [filter addTarget:self];
        [filter addTarget:self.cropFilter];
    }else{
        [self.myfilter removeAllTargets];
        [self.myfilter addTarget:self];
        [self.myfilter addTarget:self.cropFilter];
    }
}

- (void)setMyfilter:(GPUImageFilter *)myfilter {
    objc_setAssociatedObject(self, &myfilterKey, myfilter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GPUImageFilter *)myfilter {
    return objc_getAssociatedObject(self, &myfilterKey);
}

- (void)setCropFilter:(GPUImageCropFilter *)cropFilter {
    objc_setAssociatedObject(self, &cropFilterKey, cropFilter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GPUImageCropFilter *)cropFilter {
    return objc_getAssociatedObject(self, &cropFilterKey);
}

- (void)setTemp:(WorkView *)temp {
    objc_setAssociatedObject(self, &tempKey, temp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (WorkView *)temp {
    return objc_getAssociatedObject(self, &tempKey);
}

- (void)setOutput:(IRGLView *)output {
    objc_setAssociatedObject(self, &outputKey, output, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.cropFilter addTarget:output];
}

- (IRGLView *)output {
    return objc_getAssociatedObject(self, &outputKey);
}

- (void)setEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, &enabledKey, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)enabled {
    return [objc_getAssociatedObject(self, &enabledKey) boolValue];
}

- (void)setScissorRect:(CGRect)scissorRect {
    objc_setAssociatedObject(self, &scissorRectKey, @(scissorRect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)scissorRect {
    return [objc_getAssociatedObject(self, &scissorRectKey) CGRectValue];
}

@end
