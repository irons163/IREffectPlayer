//
//  Sticker.h
//  IREffectPlayer
//
//  Created by irons on 2020/6/8.
//  Copyright © 2020 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sticker : NSObject

@property (assign, nonatomic) NSInteger stickerID;
@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
