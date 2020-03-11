//
//  FilterItem.h
//  EnViewerSOHO
//
//  Created by Phil on 2017/12/21.
//  Copyright © 2017年 sniApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GPUImageOutput;
@interface FilterItem : NSObject
@property (assign, nonatomic) NSInteger filterID;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) GPUImageOutput *filter;
@end
