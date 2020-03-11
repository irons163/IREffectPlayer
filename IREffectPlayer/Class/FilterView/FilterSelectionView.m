//
//  StickerSelectionView.m
//  sticker
//
//  Created by LiuZiyang on 15/2/3.
//  Copyright (c) 2015年 LiuZiyang. All rights reserved.
//

#import "FilterSelectionView.h"
#import "FilterCell.h"
#import "FilterItem.h"
#import "GPUImageGrayscaleFilter.h"
#import "GPUImageWhiteBalanceFilter.h"
#import "GPUImageSketchFilter.h"
#import "GPUImageColorInvertFilter.h"
#import "GPUImageLuminanceThresholdFilter.h"
#import "GPUImageFilterGroup.h"
#import "GPUImageAverageLuminanceThresholdFilter.h"
#import "GPUImageContrastFilter.h"
#import "GPUImageAdaptiveThresholdFilter.h"
#import "GPUImageSharpenFilter.h"


@interface FilterSelectionView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray *stickerArray;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@end
@implementation FilterSelectionView

#pragma mark - init

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.stickerArray = [NSMutableArray array];
        FilterItem *sticker = [[FilterItem alloc] init];
        sticker.image = [UIImage imageNamed:@"origin_thumb"];
        sticker.filter = nil;
        [self.stickerArray addObject:sticker];
        sticker = [[FilterItem alloc] init];
        sticker.image = [UIImage imageNamed:@"gray_scale"];
        sticker.filter = [[GPUImageGrayscaleFilter alloc] init];
        [self.stickerArray addObject:sticker];
        sticker = [[FilterItem alloc] init];
        sticker.image = [UIImage imageNamed:@"black_white_filter"];
//        GPUImageWhiteBalanceFilter *whiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
//        whiteBalanceFilter.tint = 50.0f;
//        sticker.filter = whiteBalanceFilter;
        GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc] init];
//        GPUImageGrayscaleFilter *whiteBlackFilter = [[GPUImageGrayscaleFilter alloc] init];
////        GPUImageLuminanceThresholdFilter *luminanceThresholdFilter = [[GPUImageLuminanceThresholdFilter alloc] init];
////        luminanceThresholdFilter.threshold = 0.5f;
//        GPUImageAverageLuminanceThresholdFilter *luminanceThresholdFilter = [[GPUImageAverageLuminanceThresholdFilter alloc] init];
//        luminanceThresholdFilter.thresholdMultiplier = 0.9f;
//        [group addFilter:whiteBlackFilter];
//        [group addFilter:luminanceThresholdFilter];
//        [whiteBlackFilter addTarget:luminanceThresholdFilter];
//        [group setInitialFilters:@[whiteBlackFilter]];
//        [group setTerminalFilter:luminanceThresholdFilter];
        
        GPUImageContrastFilter *contrastfilter =[[GPUImageContrastFilter alloc]init];
        [contrastfilter setContrast:3];
        GPUImageAdaptiveThresholdFilter *stillImageFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
        stillImageFilter.blurRadiusInPixels = 8.0;
        GPUImageSharpenFilter *sharpenFilter = [[GPUImageSharpenFilter alloc] init];
        [sharpenFilter setSharpness:10];
        [group addFilter:contrastfilter];
        [group addFilter:stillImageFilter];
        [group addFilter:sharpenFilter];
        [contrastfilter addTarget:stillImageFilter];
        [stillImageFilter addTarget:sharpenFilter];
        [group setInitialFilters:@[contrastfilter]];
        [group setTerminalFilter:sharpenFilter];
        
        sticker.filter = group;
        [self.stickerArray addObject:sticker];
        sticker = [[FilterItem alloc] init];
        sticker.image = [UIImage imageNamed:@"sketch"];
        sticker.filter = [[GPUImageSketchFilter alloc] init];
        [self.stickerArray addObject:sticker];
        sticker = [[FilterItem alloc] init];
        sticker.image = [UIImage imageNamed:@"invert_color"];
        sticker.filter = [[GPUImageColorInvertFilter alloc] init];
        [self.stickerArray addObject:sticker];
    }
    return self;
}

#pragma mark - collectionview data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.stickerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FilterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];
    cell.filterItem = self.stickerArray[indexPath.row];
//    if([collectionView.indexPathsForSelectedItems count] == 0 && indexPath.row == 0){
//        cell.layer.borderWidth = 2;
//        cell.layer.borderColor = [[UIColor redColor] CGColor];
//    }
    return cell;
}

#pragma mark - collectionview delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectStickerSuccessBlock(self.stickerArray[indexPath.row]);
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 2;
    cell.layer.borderColor = [[UIColor redColor] CGColor];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0;
}

@end
