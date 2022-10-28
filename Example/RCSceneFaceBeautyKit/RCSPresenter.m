//
//  RCSPresenter.m
//  RCSceneFaceBeautyKit_Example
//
//  Created by 彭蕾 on 2022/9/15.
//  Copyright © 2022 彭蕾. All rights reserved.
//

#import "RCSPresenter.h"
#import "RequestToken.h"
#import "Constant.h"
#import <RongRTCLib/RongRTCLib.h>
#import <RongIMLibCore/RongIMLibCore.h>

@implementation RCSPresenter

- (void)initRTCRoom:(nullable void (^)(RCRTCRoom *_Nullable room))completion {
    
    [[RCCoreClient sharedCoreClient] setServerInfo:@"http://nav-ucqa.rongcloud.net"
                                        fileServer:@"http://nav-ucqa.rongcloud.net"];
    [[RCCoreClient sharedCoreClient] initWithAppKey:AppKey];

    [RequestToken requestToken:@"111"
                          name:@"111"
                   portraitUrl:nil
             completionHandler:^(BOOL isSuccess, NSString *_Nonnull tokenString) {
                 if (!isSuccess) {
                     !completion ?: completion(nil);
                 }
                 // 拿到 Token 后去连接 IM 服务
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self connectRongCloud:tokenString completion:completion];
                 });
             }];
}

#pragma mark - IM 相关
// 初始化 AppKey 并连接 IM
- (void)connectRongCloud:(NSString *)token completion:(nullable void (^)(RCRTCRoom *_Nullable room))completion {
    [[RCCoreClient sharedCoreClient] connectWithToken:token
        dbOpened:nil
        success:^(NSString *userId) {
            NSLog(@"IM connect success,user ID : %@", userId);
            // 回调处于子线程，需要回调到主线程进行 UI 处理。
            dispatch_async(dispatch_get_main_queue(), ^{
                [self joinRoom:completion];
            });
        }
        error:^(RCConnectErrorCode errorCode) {
            !completion ?: completion(nil);
            NSLog(@"IM connect failed, error code : %ld", (long)errorCode);
        }];
}

- (void)joinRoom:(nullable void (^)(RCRTCRoom *_Nullable room))completion {
    BOOL isAudience = [[RCCoreClient sharedCoreClient].currentUserInfo.userId isEqualToString:@"333"];
    RCRTCRoomConfig *config = [RCRTCRoomConfig new];
    config.roomType = RCRTCRoomTypeLive;
    config.liveType = RCRTCLiveTypeAudioVideo;
    config.roleType = isAudience ? RCRTCLiveRoleTypeAudience : RCRTCLiveRoleTypeBroadcaster;
    
    RCRTCVideoStreamConfig *videoConfig = [RCRTCVideoStreamConfig new];
    videoConfig.videoSizePreset = RCRTCVideoSizePreset1920x1080;
    videoConfig.videoFps = RCRTCVideoFPS30;
    
    [[RCRTCEngine sharedInstance].defaultVideoStream setVideoConfig:videoConfig];

    [[RCRTCEngine sharedInstance] joinRoom:@"16543211"
                                    config:config
                                completion:^(RCRTCRoom *_Nullable room, RCRTCCode code) {
                                    NSLog(@"joinRoom ------> %ld", (long)code);
                                    !completion ?: completion(room);
                                    /// 1. 发布
                                    if (room.roomConfig.roleType == RCRTCLiveRoleTypeBroadcaster) {
                                        [self publish];
                                    }

                                    /// 2. 订阅
                                    if (room.remoteUsers.count) {
                                        [self updateSubcribeInRoom:room];
                                    }
                                }];
}


- (void)publish {
    [[RCRTCEngine sharedInstance].room.localUser
        publishDefaultLiveStreams:^(BOOL isSuccess, RCRTCCode code, RCRTCLiveInfo *_Nullable liveInfo) {
            NSLog(@"publishDefaultLiveStreams ------> %ld", (long)code);
        }];
}

- (void)updateSubcribeInRoom:(RCRTCRoom *)room {
    if (room.roomConfig.roleType == RCRTCLiveRoleTypeAudience) {
        NSArray *liveStreams = [room getLiveStreams];
        if (liveStreams.count) {
            // 观众可以在此订阅合流
            [self subcribe:liveStreams];
        }
    }

    if (room.roomConfig.roleType == RCRTCLiveRoleTypeBroadcaster) {
        for (RCRTCRemoteUser *user in room.remoteUsers) {
            // 参与的远端用户的音视频流
            if (user.remoteStreams.count) {
                // 订阅远端音视频资源
                [self subcribe:user.remoteStreams];
            }
        }
    }
}

- (void)subcribe:(NSArray<RCRTCInputStream *> *)avStreams {
    // 订阅房间中远端用户音视频流资源
    [[RCRTCEngine sharedInstance].room.localUser subscribeStream:avStreams
                                                     tinyStreams:@[]
                                                      completion:^(BOOL isSuccess, RCRTCCode desc) {
                                                          if (desc != RCRTCCodeSuccess) {
                                                              return;
                                                          }
                                                      }];
}


@end
