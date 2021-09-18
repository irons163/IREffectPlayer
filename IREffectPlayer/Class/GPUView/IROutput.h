//
//  IROutput.h
//  demo
//
//  Created by irons on 2020/2/10.
//  Copyright © 2020 irons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImageOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface IROutput : GPUImageOutput

@property (nonatomic) CGRect viewprotRange;

- (void)setOutputFramebuffer:(GPUImageFramebuffer *)outputFramebuffer;
- (void)processProgram;

@end

NS_ASSUME_NONNULL_END
