//
//  StickerCell.m
//  sticker
//
//  Created by LiuZiyang on 15/2/3.
//  Copyright (c) 2015年 LiuZiyang. All rights reserved.
//

#import "FilterCell.h"
#import "FilterItem.h"

@interface FilterCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FilterCell

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.layer.borderWidth = 1.f;
    }
    return self;
}

- (void)setFilterItem:(FilterItem *)filterItme{
    _filterItem = filterItme;
    self.imageView.image = filterItme.image;
}

@end
