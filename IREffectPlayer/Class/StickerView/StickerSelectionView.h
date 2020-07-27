//
//  StickerSelectionView.h
//  IREffectPlayer
//
//  Created by irons on 2020/6/8.
//  Copyright © 2020 irons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sticker.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectStickerSuccessBlock)(Sticker *sticker);

@interface StickerSelectionView : UIView
@property (strong, nonatomic) SelectStickerSuccessBlock selectStickerSuccessBlock;
@end

NS_ASSUME_NONNULL_END
