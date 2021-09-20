//
//  GifSelectionView.m
//  IREffectPlayer
//
//  Created by irons on 2021/9/19.
//  Copyright © 2021 irons. All rights reserved.
//

#import "GifSelectionView.h"
#import "GifModel.h"
#import "GifCell.h"

@interface GifSelectionView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray *stickerArray;
@property (weak, nonatomic) IBOutlet UICollectionView *filterCollectionView;
@end
@implementation GifSelectionView

#pragma mark - init

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        self.stickerArray = [NSMutableArray array];
        GifModel *sticker = [[GifModel alloc] init];
        NSData *gifImageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"fatdog-dog"] ofType:@"gif" inDirectory:nil]];
        FLAnimatedImage* animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifImageData];
        sticker.image = animatedImage;
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
    GifCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GifCell" forIndexPath:indexPath];
    cell.gifModel = self.stickerArray[indexPath.row];
//    if([collectionView.indexPathsForSelectedItems count] == 0 && indexPath.row == 0){
//        cell.layer.borderWidth = 2;
//        cell.layer.borderColor = [[UIColor redColor] CGColor];
//    }
    return cell;
}

#pragma mark - collectionview delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectGifModelSuccessBlock(self.stickerArray[indexPath.row]);
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 2;
    cell.layer.borderColor = [[UIColor redColor] CGColor];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0;
}

@end
