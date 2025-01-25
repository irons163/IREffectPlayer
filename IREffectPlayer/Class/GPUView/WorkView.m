//
//  WorkView.m
//  sticker
//
//  Created by LiuZiyang on 15/2/3.
//  Copyright (c) 2015年 LiuZiyang. All rights reserved.
//

#import "WorkView.h"
#import <IRSticker/IRSticker.h>
#import "GifModel.h"

#import "Sticker.h"
#import "FLAnimatedImageView.h"

@interface WorkView()<IRStickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *baseImageView;

@property (strong, nonatomic) UIImage *baseImage;

@property (strong, nonatomic) NSMutableArray *stickerViewArray;

@end

@implementation WorkView

- (BOOL)hasImage{
    return (BOOL)self.baseImage;
}

#pragma mark - init

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.stickerViewArray = [@[] mutableCopy];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.stickerViewArray = [@[] mutableCopy];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark - base image

- (void)setBaseImage:(UIImage *)baseImage {
    [self clearStickers];
    _baseImage = baseImage;
    self.baseImageView.image = baseImage;
}

#pragma mark - sticker

- (void)addSticker:(Sticker *)sticker {
    [self hideAllStickerEditing];
    IRStickerView *newStickerView = [[IRStickerView alloc] initWithContentFrame:CGRectMake(0, 0, sticker.image.size.width, sticker.image.size.height) contentImage:sticker.image];
    newStickerView.delegate = self;
    [self.stickerViewArray addObject:newStickerView];
    [self addSubview:newStickerView];
}

- (void)clearStickers {
    for (UIView *view in self.stickerViewArray){
        [view removeFromSuperview];
    }
    [self.stickerViewArray removeAllObjects];
}

- (void)addGifModel:(GifModel *)gifModel {
    [self hideAllStickerEditing];
    
    FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] init];
    gifImageView.frame = CGRectMake(0, 0, gifModel.image.size.width, gifModel.image.size.height);
    [gifImageView setAnimatedImage:gifModel.image];
    gifImageView.backgroundColor = [UIColor clearColor];
    [gifImageView startAnimating];
    
    IRStickerView *newStickerView = [[IRStickerView alloc] initWithContentFrame:CGRectMake(0, 0, gifModel.image.size.width, gifModel.image.size.height) contentImageView:gifImageView];
    newStickerView.delegate = self;
    [self.stickerViewArray addObject:newStickerView];
    [self addSubview:newStickerView];
}

- (void)nextFrameIndexForInterval:(NSTimeInterval)interval {
    for (UIView *v in self.subviews) {
//        if ([v isKindOfClass:FLAnimatedImageView.class]) {
//            FLAnimatedImageView *gifImageView = v;
//            [gifImageView nextFrameIndexForInterval:interval];
//        }
        if ([v isKindOfClass:IRStickerView.class] && [((IRStickerView*)v).contentView isKindOfClass:FLAnimatedImageView.class]) {
            FLAnimatedImageView *gifImageView = ((IRStickerView*)v).contentView;
            [gifImageView nextFrameIndexForInterval:interval];
        }
    }
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
    
}

- (void)hideAllStickerEditing {
    for (UIView *view in self.stickerViewArray){
        if ([view isKindOfClass:IRStickerView.class]) {
            IRStickerView *stickerView = view;
            if(![stickerView enabledBorder]){
                continue;
            }
                
            //        [stickerView hideEditingHandles];
            [stickerView setEnabledControl:NO];
            [stickerView setEnabledBorder:NO];
        } else if ([view isKindOfClass:FLAnimatedImageView.class]) {
            if (view.superview != self) {
                continue;
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(hideEditingHandles:)]) {
            [self.delegate hideEditingHandles:view];
        }
    }
}

#pragma mark - Sticker view delegte

- (void)ir_StickerViewDidTapContentView:(IRStickerView *)sticker {
    for (IRStickerView *stickerView in self.stickerViewArray){
        if (stickerView == sticker){
            continue;
        }
        [stickerView setEnabledControl:NO];
        [stickerView setEnabledBorder:NO];
        
        if ([self.delegate respondsToSelector:@selector(hideEditingHandles:)])
        {
            [self.delegate hideEditingHandles:stickerView];
        }
    }
    sticker.enabledBorder = YES;
    sticker.enabledControl = YES;
    
    if ([self.delegate respondsToSelector:@selector(showEditingHandles:)])
    {
        [self.delegate showEditingHandles:sticker];
    }
}

- (void)stickerViewDidClose:(IRStickerView *)sticker {
    [self.stickerViewArray removeObject:sticker];
}

#pragma mark - generate

- (void)generateWithBlock:(void (^)(UIImage *, NSError *))block {
    for (IRStickerView *stickerView in self.stickerViewArray){
        [stickerView setEnabledControl:NO];
        [stickerView setEnabledBorder:NO];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.baseImage drawInRect:self.bounds];
    for (IRStickerView *stickerView in self.stickerViewArray) {
        CGContextSaveGState(context);
        // Generate pure imageview
//        UIImage *image = [(UIImageView *)stickerView.contentView image];
//        UIImageView *view = [[UIImageView alloc] initWithFrame:stickerView.frame];
//        CGRect frame = view.frame;
//        frame.size = stickerView.contentView.frame.size;
//        view.frame = frame;
//        view.image = image;
//        view.transform = stickerView.transform;
        UIView *view = stickerView;
        // Center the context around the view's anchor point
        CGContextTranslateCTM(context, [view center].x, [view center].y);
        // Apply the view's transform about the anchor point
        CGContextConcatCTM(context, [view transform]);
        // Offset by the portion of the bounds left of and above the anchor point
        CGContextTranslateCTM(context,
                              -[view bounds].size.width * [[view layer] anchorPoint].x,
                              -[view bounds].size.height * [[view layer] anchorPoint].y);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        CGContextRestoreGState(context);
    }
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    block(ret, nil);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        
    if(self.enableEditing && _drawView){
        UIView *hitTestView = nil;
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        
        hitTestView = [_drawView hitTest:point withEvent:event];
        if (hitTestView) {
            return hitTestView;
        }

        [self hideAllStickerEditing];
        
        return nil;
    } else {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        [self hideAllStickerEditing];
        return nil;
    }
        
    }
    return nil;
}

@end
