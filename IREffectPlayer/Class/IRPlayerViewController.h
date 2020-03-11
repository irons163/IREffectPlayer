//
//  IRPlayerViewController.h
//  IREffectPlayer
//
//  Created by irons on 2020/2/27.
//  Copyright © 2020 irons. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DemoType) {
    DemoType_AVPlayer_Normal = 0,
    DemoType_AVPlayer_VR,
    DemoType_AVPlayer_VR_Box,
    DemoType_FFmpeg_Normal,
    DemoType_FFmpeg_Normal_Hardware,
    DemoType_FFmpeg_Fisheye_Hardware,
    DemoType_FFmpeg_Panorama_Hardware,
    DemoType_FFmpeg_MultiModes_Hardware_Modes_Selection,
};

@interface IRPlayerViewController : UIViewController

@property (nonatomic, assign) DemoType demoType;

@end

NS_ASSUME_NONNULL_END
