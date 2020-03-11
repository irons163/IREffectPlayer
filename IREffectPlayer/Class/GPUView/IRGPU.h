//
//  IRGPU.h
//  demo
//
//  Created by irons on 2020/2/7.
//  Copyright © 2020年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IRPlayer/IRPlayer.h>
#import <IRPlayer/IRGLView.h>
#import "WorkView.h"
#import "StickerView.h"
#import "GPUImageContext.h"

#import "GPUImageFilter.h"
#import "GPUImageCropFilter.h"
#import "IROutput.h"

@class GPUImageFilter;
@class GPUImageView;
@class GPUImageOutput;

@interface IRGLView(AA)<GPUImageInput>

@property (strong, nonatomic) WorkView *temp;
@property (strong, nonatomic) IRGLView* output;
@property(nonatomic) BOOL enabled;
@property (nonatomic) CGRect scissorRect;

@property (strong, nonatomic) GLProgram *displayProgram;
@property (nonatomic) GLint displayPositionAttribute, displayTextureCoordinateAttribute;
@property (nonatomic) GLint displayInputTextureUniform;

@property (nonatomic) GLuint displayRenderbuffer, displayFramebuffer;
@property (nonatomic) CGSize boundsSizeAtFrameBufferEpoch;
@property (nonatomic) CGSize inputImageSize;
@property (strong, nonatomic) GPUImageFramebuffer *inputFramebufferForDisplay;

@property (nonatomic) GPUImageRotationMode inputRotation;

@property (strong, nonatomic) GPUImageFilter *filter, *myfilter;
@property (strong, nonatomic) GPUImageCropFilter *cropFilter;


- (void)updateStickViews:(NSArray<StickerView*>*)stickViews;

//- (GPUImageFilter*)getFilter;
//- (void)setFilter:(GPUImageOutput<GPUImageInput>*)filter;
//- (void)setOutput:(GPUImageView *)output;

- (void)setCurrentContext;
- (BOOL)clearCurrentBuffer;
- (void)bindCurrentRenderBuffer;
- (BOOL)presentRenderBuffer;

@end
