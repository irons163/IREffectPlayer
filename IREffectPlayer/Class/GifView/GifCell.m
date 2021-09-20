//
//  GifCell.m
//  IREffectPlayer
//
//  Created by irons on 2021/9/19.
//  Copyright © 2021 irons. All rights reserved.
//

#import "GifCell.h"

@interface GifCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GifCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        self.layer.borderWidth = 1.f;
    }
    return self;
}

- (void)setGifModel:(GifModel *)gifModel {
    _gifModel = gifModel;
    self.imageView.image = gifModel.image.posterImage;
}

@end
