//
//  RCSViewController.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 09/14/2022.
//  Copyright (c) 2022 彭蕾. All rights reserved.
//

#import "RCSViewController.h"
#import <RongIMLibCore/RongIMLibCore.h>
#import <RongFUFaceBeautifier/RongFUFaceBeautifier.h>
#import <RCSceneFaceBeautyKit/RCSFaceBeautyKit.h>
#import "RCSPresenter.h"
#import "authpack.h"
#import <RCSceneNetworkKit/RCSNetworkKit.h>

@interface RCSViewController () <RCRTCRoomEventDelegate, RCSBeautyEngineDataSource>

@property (nonatomic, strong) RCSPresenter *presenter;
@property (nonatomic, strong) RCRTCVideoView *previewView;
@property (nonatomic, strong) UIButton *showBeautyBtn;
@property (nonatomic, strong) UIButton *showStickerBtn;

@end

@implementation RCSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.previewView];
    [self.view addSubview:self.showBeautyBtn];
    [self.view addSubview:self.showStickerBtn];

    [self.presenter initRTCRoom:^(RCRTCRoom *_Nullable room) {
        if (!room)
            return;
        room.delegate = self;

        [RCRTCEngine.sharedInstance.defaultVideoStream setVideoView:self.previewView];
        [[RCRTCEngine sharedInstance].defaultVideoStream startCapture];

        [[RCSBeautyEngine sharedInstance] registerWithAuthPackage:&g_auth_package authSize:sizeof(g_auth_package)];
        [RCSBeautyEngine sharedInstance].dataSource = self;
    }];
}

- (void)showBeauty {
    [[RCSBeautyEngine sharedInstance] showIn:self withType:0];
}

- (void)showSticker {
    [[RCSBeautyEngine sharedInstance] showIn:self withType:1];
}

#pragma mark - RCRTCRoomEventDelegate
- (void)didJoinUser:(RCRTCRemoteUser *)user {
}

- (void)didLeaveUser:(RCRTCRemoteUser *)user {
}

/// 远端用户发布资源通知
- (void)didPublishStreams:(NSArray<RCRTCInputStream *> *)streams {
    RCRTCRoom *room = [RCRTCEngine sharedInstance].room;
    [self.presenter updateSubcribeInRoom:room];
}

/// 远端直播合流发布资源通知
- (void)didPublishLiveStreams:(NSArray<RCRTCInputStream *> *)streams {
    RCRTCRoom *room = [RCRTCEngine sharedInstance].room;
    [self.presenter updateSubcribeInRoom:room];
}

#pragma mark - lazyload
- (RCSPresenter *)presenter {
    if (!_presenter) {
        _presenter = [RCSPresenter new];
    }
    return _presenter;
}

- (RCRTCVideoView *)previewView {
    if (!_previewView) {
        _previewView = [[RCRTCVideoView alloc] initWithFrame:self.view.bounds];
        _previewView.fillMode = RCRTCVideoFillModeAspectFill;
    }
    return _previewView;
}

- (UIButton *)showBeautyBtn {
    if (!_showBeautyBtn) {
        _showBeautyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _showBeautyBtn.backgroundColor = [UIColor redColor];
        _showBeautyBtn.frame = CGRectMake(100, 100, 100, 30);
        [_showBeautyBtn setTitle:@"美颜" forState:UIControlStateNormal];
        [_showBeautyBtn addTarget:self action:@selector(showBeauty) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBeautyBtn;
}

- (UIButton *)showStickerBtn {
    if (!_showStickerBtn) {
        _showStickerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _showStickerBtn.backgroundColor = [UIColor redColor];
        _showStickerBtn.frame = CGRectMake(220, 100, 100, 30);
        [_showStickerBtn setTitle:@"贴纸" forState:UIControlStateNormal];
        [_showStickerBtn addTarget:self action:@selector(showSticker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showStickerBtn;
}

#pragma mark - RCSBeautyEngineDataSource
- (RCSBeautyRenderConfig *)customBeautyRenderConfig {
    RCSBeautyRenderConfig *config = [RCSBeautyRenderConfig new];
    
    config.isFromFrontCamera = YES;
    config.stickerFlipH = YES;
    config.isFromMirroredCamera = YES;
    
    return config;
}

- (RCSBeautyNetworkConfig *)customBeautyNetworkConfig {
    RCSBeautyNetworkConfig *config = [RCSBeautyNetworkConfig new];
    
#warning 配置网络信息
    config.baseUrl = @"https://rcrtc-api.rongcloud.net/";
    config.businessToken = @"";
    config.auth = @"";
    
    return config;
}

@end
