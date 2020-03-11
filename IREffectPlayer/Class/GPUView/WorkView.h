//
//  WorkView.h
//  sticker
//
//  Created by LiuZiyang on 15/2/3.
//  Copyright (c) 2015年 LiuZiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Sticker;
@protocol WorkViewDelegate;

@interface WorkView : UIView

@property (assign, nonatomic) id<WorkViewDelegate> delegate;
@property (weak, nonatomic) WorkView* drawView;
@property (nonatomic) BOOL enableEditing;

- (BOOL)hasImage;
- (void)setBaseImage:(UIImage *)baseImage;

- (void)clearStickers;
- (void)addSticker:(Sticker *)sticker;

- (void)generateWithBlock:(void(^)(UIImage *finalImage, NSError *error))block;
@end

@protocol WorkViewDelegate <NSObject>

@optional

- (void)hideEditingHandles:(UIView *)stickerView;

- (void)showEditingHandles:(UIView *)stickerView;

- (void)hideAllStickerEditing;

//- (UIImage *)stickerView:(WorkView *)stickerView imageForRightTopControl:(CGSize)recommendedSize;
//
//- (void)stickerViewDidTapRightTopControl:(WorkView *)stickerView; // Effective when resource is provided.
//
//- (UIImage *)stickerView:(WorkView *)stickerView imageForLeftBottomControl:(CGSize)recommendedSize;
//
//- (void)stickerViewDidTapLeftBottomControl:(WorkView *)stickerView; // Effective when resource is provided.

@end
