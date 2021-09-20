//
//  GifSelectionView.h
//  IREffectPlayer
//
//  Created by irons on 2021/9/19.
//  Copyright © 2021 irons. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GifModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectGifModelSuccessBlock)(GifModel *sticker);

@interface GifSelectionView : UIView

@property (strong, nonatomic) SelectGifModelSuccessBlock selectGifModelSuccessBlock;

@end

NS_ASSUME_NONNULL_END
