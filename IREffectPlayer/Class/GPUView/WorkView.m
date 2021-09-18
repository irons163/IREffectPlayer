//
//  WorkView.m
//  sticker
//
//  Created by LiuZiyang on 15/2/3.
//  Copyright (c) 2015年 LiuZiyang. All rights reserved.
//

#import "WorkView.h"
#import <IRSticker/IRSticker.h>

#import "Sticker.h"

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
    for (IRStickerView *stickerView in self.stickerViewArray){
        [stickerView removeFromSuperview];
    }
    [self.stickerViewArray removeAllObjects];
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
    
}

-(void)hideAllStickerEditing{
    for (IRStickerView *stickerView in self.stickerViewArray){
        if(![stickerView enabledBorder]){
            continue;
        }
            
        //        [stickerView hideEditingHandles];
        [stickerView setEnabledControl:NO];
        [stickerView setEnabledBorder:NO];
        
        if ([self.delegate respondsToSelector:@selector(hideEditingHandles:)])
        {
            [self.delegate hideEditingHandles:stickerView];
        }
    }
}

#pragma mark - Sticker view delegte

-(void)stickerViewDidTapContentView:(IRStickerView *)sticker {
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

//- (void)stickerViewDidBeginEditing:(StickerView *)sticker{
//    for (StickerView *stickerView in self.stickerViewArray){
//        if (stickerView == sticker){
//            continue;
//        }
//        [stickerView setEnabledControl:NO];
//        [stickerView setEnabledBorder:NO];
//    }
//}

-(void)stickerViewDidEndEditing:(IRStickerView *)stickerView{
    [stickerView setEnabledControl:NO];
    [stickerView setEnabledBorder:NO];
    
    if ([self.delegate respondsToSelector:@selector(hideEditingHandles:)])
    {
        [self.delegate hideEditingHandles:stickerView];
    }
}

//-(void)stickerViewDidCancelEditing:(StickerView *)stickerView{
//    [stickerView setEnabledControl:NO];
//    [stickerView setEnabledBorder:NO];
//}

- (void)stickerViewDidClose:(IRStickerView *)sticker {
    [self.stickerViewArray removeObject:sticker];
}

//#pragma mark - touch
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    for (StickerView *stickerView in self.stickerViewArray){
//        [stickerView setEnabledControl:NO];
//    }
//}

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
    }
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
    return nil;
}

@end
