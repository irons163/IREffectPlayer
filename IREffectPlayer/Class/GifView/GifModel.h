//
//  GifModel.h
//  IREffectPlayer
//
//  Created by irons on 2021/9/19.
//  Copyright © 2021 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLAnimatedImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface GifModel : NSObject

@property (assign, nonatomic) NSInteger gifID;
@property (strong, nonatomic) FLAnimatedImage *image;

@end

NS_ASSUME_NONNULL_END
