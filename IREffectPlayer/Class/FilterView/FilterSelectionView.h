//
//  StickerSelectionView.h
//  sticker
//
//  Created by LiuZiyang on 15/2/3.
//  Copyright (c) 2015年 LiuZiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Sticker.h"

@class FilterItem;

typedef void(^SelectFilterSuccessBlock)(FilterItem *sticker);

@interface FilterSelectionView : UIView
@property (strong, nonatomic) SelectFilterSuccessBlock selectStickerSuccessBlock;
@end
