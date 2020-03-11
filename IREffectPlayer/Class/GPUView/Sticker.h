//
//  Sticker.h
//  demo
//
//  Created by irons on 2019/11/5.
//  Copyright © 2019年 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sticker : NSObject

@property (assign, nonatomic) NSInteger stickerID;
@property (strong, nonatomic) UIImage *image;

@end

NS_ASSUME_NONNULL_END
