//
//  StickerCell.m
//  IREffectPlayer
//
//  Created by irons on 2020/6/8.
//  Copyright © 2020 irons. All rights reserved.
//

#import "StickerCell.h"

@interface StickerCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation StickerCell

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.layer.borderWidth = 1.f;
    }
    return self;
}

- (void)setSticker:(Sticker *)sticker {
    _sticker = sticker;
    self.imageView.image = sticker.image;
}

@end
