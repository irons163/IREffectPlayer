//
//  IRPlayerViewController.m
//  IREffectPlayer
//
//  Created by irons on 2020/2/27.
//  Copyright © 2020 irons. All rights reserved.
//

#import "IRPlayerViewController.h"
#import "IRGPU.h"
#import <IRPlayer/IRPlayer.h>
#import "StickerSelectionView.h"
#import "FilterSelectionView.h"
#import "GifSelectionView.h"
#import "FilterItem.h"
#import "IRGPUPreview.h"
#import <objc/runtime.h>

@interface IRPlayerViewController ()<WorkViewDelegate> {
    __weak IBOutlet UIView *stickerSelectionBoard;
    __weak IBOutlet UIButton *gifModeButton;
    __weak IBOutlet UIButton *stickerModeButton;
    __weak IBOutlet UIButton *filterModeButton;
    __weak IBOutlet UIButton *effectModeButton;
    __weak IBOutlet UIButton *faceModeButton;
    __weak IBOutlet UIButton *editModeButton;
    __weak IBOutlet NSLayoutConstraint *stickerSelectionBoardTopConstraint;
    
    UITabBarController *desVC;
    
    //    VCIPCamSession* session;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) WorkView *workView;
@property (weak, nonatomic) WorkView *drawView;

@property (nonatomic, strong) IRPlayerImp * player;

@end

@implementation IRPlayerViewController

+ (void)load {
    SEL sel = sel_getUid("createGLView");
    Class IDEIndexClangQueryProviderClass = NSClassFromString(@"IRPlayerImp");
    
    Method method = class_getInstanceMethod(IDEIndexClangQueryProviderClass, sel);
    IMP originalImp = method_getImplementation(method);
    
    IMP imp = imp_implementationWithBlock(^id(id me) {
        //        id ret = ((id (*)(id,SEL))originalImp)(me, sel);
        
        // do work
        id ret = [[IRGPU alloc] init];
        
        return ret;
    });
    
    method_setImplementation(method, imp);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.player updateGraphicsViewFrame:self.view.bounds];
    //    [((IRGPU *)self.player.view) updateSize];
    //    [((IRGPU *)self.player.view) setRenderModes:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    static NSURL * normalVideo = nil;
    static NSURL * vrVideo = nil;
    static NSURL * fisheyeVideo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        normalVideo = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"i-see-fire" ofType:@"mp4"]];
        vrVideo = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"google-help-vr" ofType:@"mp4"]];
        fisheyeVideo = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fisheye-demo" ofType:@"mp4"]];
    });
    
    self.player = [IRPlayerImp player];
    [self.player registerPlayerNotificationTarget:self
                                      stateAction:@selector(stateAction:)
                                   progressAction:@selector(progressAction:)
                                   playableAction:@selector(playableAction:)
                                      errorAction:@selector(errorAction:)];
    [self.player setViewTapAction:^(IRPlayerImp * _Nonnull player, IRPLFView * _Nonnull view) {
        NSLog(@"player display view did click!");
    }];
    self.player.decoder = [IRPlayerDecoder FFmpegDecoder];
    [self.mainView insertSubview:self.player.view atIndex:0];
//    IRGLRenderMode2D *mode = [[IRGLRenderMode2D alloc] init];
//    mode.aspect = 16.0/9.0;

    [self.player replaceVideoWithURL:normalVideo];
//    self.player.renderModes = @[mode];
    //    IRGPUPreview *i = [[IRGPUPreview alloc] initWithFrame:CGRectMake(0, 0, self.player.view.bounds.size.width/2, self.player.view.bounds.size.height/2)];
    //
    //    [(IRGPU *)self.player.view setOutput:i];
    //    [self.mainView addSubview:i];
    [((IRGPU *)self.player.view) updateSize];
    WorkView *workView = [[WorkView alloc] initWithFrame:self.mainView.bounds];
    workView.delegate = self;
    workView.drawView = ((IRGPU *)self.player.view).temp;
    workView.drawView.delegate = self;
    [self.mainView addSubview:workView];
    //    [self.mainView addSubview:workView.drawView];
    self.workView = workView;
    self.drawView = workView.drawView;
}

- (void)dealWithNotification:(NSNotification *)notification Player:(IRPlayerImp *)player {
    IRState * state = [IRState stateFromUserInfo:notification.userInfo];
    
    NSString * text;
    switch (state.current) {
        case IRPlayerStateNone:
            text = @"None";
            break;
        case IRPlayerStateBuffering:
            text = @"Buffering...";
            break;
        case IRPlayerStateReadyToPlay:
            text = @"Prepare";
            //            self.totalTimeLabel.text = [self timeStringFromSeconds:self.player.duration];
            [player play];
            break;
        case IRPlayerStatePlaying:
            text = @"Playing";
            break;
        case IRPlayerStateSuspend:
            text = @"Suspend";
            break;
        case IRPlayerStateFinished:
            text = @"Finished";
            break;
        case IRPlayerStateFailed:
            text = @"Error";
            break;
    }
    //    self.stateLabel.text = text;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    desVC = segue.destinationViewController;
    //    if ([[segue identifier] isEqual:@"toWorkView"]){
    //        self.workView = (WorkView *)desVC.view;
    //        return;
    //    }
    if ([[segue identifier] isEqual:@"toStickerSelectionView"]){
        //        desVC.selectedIndex = 0;
        //        self.stickerSelectionView = (StickerSelectionView *)desVC.selectedViewController.view;
        //        self.stickerSelectionView.selectStickerSuccessBlock = ^(Sticker *sticker){
        //            self.pickStickerSuccessBlock(sticker);
        //        };
        return;
    }
}

- (void)stateAction:(NSNotification *)notification {
    [self dealWithNotification:notification Player:self.player];
}

- (void)progressAction:(NSNotification *)notification {
    //    IRProgress * progress = [IRProgress progressFromUserInfo:notification.userInfo];
    //    if (!self.progressSilderTouching) {
    //        self.progressSilder.value = progress.percent;
    //    }
    //    self.currentTimeLabel.text = [self timeStringFromSeconds:progress.current];
}

- (void)playableAction:(NSNotification *)notification {
    IRPlayable * playable = [IRPlayable playableFromUserInfo:notification.userInfo];
    NSLog(@"playable time : %f", playable.current);
}

- (void)errorAction:(NSNotification *)notification {
    IRError * error = [IRError errorFromUserInfo:notification.userInfo];
    NSLog(@"player did error : %@", error.error);
}

- (NSString *)timeStringFromSeconds:(CGFloat)seconds {
    return [NSString stringWithFormat:@"%ld:%.2ld", (long)seconds / 60, (long)seconds % 60];
}

#pragma mark - WorkViewDelegate

-(void)hideEditingHandles:(UIView *)stickerView {
    [stickerView removeFromSuperview];
    WorkView * v = ((IRGPU *)self.player.view).temp;
    [v addSubview:stickerView];
}

-(void)showEditingHandles:(UIView *)stickerView {
    [stickerView removeFromSuperview];
    [self.workView addSubview:stickerView];
}

#pragma mark - IBAction

- (void)handleModeSelect:(BOOL)isSelected {
    if(isSelected){
        stickerSelectionBoard.hidden = !isSelected;
    }
    
    stickerSelectionBoard.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (isSelected) {
            self->stickerSelectionBoardTopConstraint.constant = - self->stickerSelectionBoard.frame.size.height - 50;
        } else {
            self->stickerSelectionBoardTopConstraint.constant = 44;
        }
    } completion:^(BOOL finished) {
        self->stickerSelectionBoard.userInteractionEnabled = YES;
    }];
}

- (IBAction)effectiveButtonClick:(id)sender {
    ((UIButton*)sender).selected = !((UIButton*)sender).selected;
    BOOL isSelected = ((UIButton*)sender).selected;
    
    [self handleModeSelect:isSelected];
    
    [self stickerModeClick:stickerModeButton];
}

- (IBAction)editModeClick:(id)sender {
    ((UIButton*)sender).selected = !((UIButton*)sender).selected;
    self.workView.enableEditing = ((UIButton*)sender).selected;
    self.drawView.enableEditing = ((UIButton*)sender).selected;
}

- (IBAction)stickerModeClick:(id)sender {
    ((UIButton*)sender).selected = !((UIButton*)sender).selected;
    BOOL isSelected = ((UIButton*)sender).selected;
    
    [self handleModeSelect:isSelected];
    
    if(isSelected){
        desVC.selectedIndex = 0;
        
        ((StickerSelectionView *)desVC.selectedViewController.view).selectStickerSuccessBlock = ^(Sticker *sticker){
            //            self.pickStickerSuccessBlock(sticker);
            //            [((IRGPU *)self.player.view) addFilter:filter.filter];
            [self.workView addSticker:sticker];
        };
        
        filterModeButton.selected = !isSelected;
        effectModeButton.selected = !isSelected;
        gifModeButton.selected = !isSelected;
    }
}

- (IBAction)filterModeClick:(id)sender {
    ((UIButton*)sender).selected = !((UIButton*)sender).selected;
    BOOL isSelected = ((UIButton*)sender).selected;
    
    [self handleModeSelect:isSelected];
    
    if (isSelected) {
        desVC.selectedIndex = 2;
        
        ((FilterSelectionView*)desVC.selectedViewController.view).selectStickerSuccessBlock = ^(FilterItem *filter){
            //            self.pickStickerSuccessBlock(sticker);
            [((IRGPU *)self.player.view) addFilter:filter.filter];
        };
        
        stickerModeButton.selected = !isSelected;
        effectModeButton.selected = !isSelected;
        gifModeButton.selected = !isSelected;
    }
}

- (IBAction)gifModeClick:(id)sender {
    ((UIButton*)sender).selected = !((UIButton*)sender).selected;
    BOOL isSelected = ((UIButton*)sender).selected;
    
    [self handleModeSelect:isSelected];
    
    if(isSelected){
        desVC.selectedIndex = 1;
        
        ((GifSelectionView *)desVC.selectedViewController.view).selectGifModelSuccessBlock = ^(GifModel * _Nonnull sticker) {
            [self.workView addGifModel:sticker];
        };
        
        stickerModeButton.selected = !isSelected;
        filterModeButton.selected = !isSelected;
        effectModeButton.selected = !isSelected;
    }
}

@end
