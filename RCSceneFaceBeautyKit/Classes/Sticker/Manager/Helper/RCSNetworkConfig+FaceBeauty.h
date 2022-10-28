//
//  RCSNetworkConfig+FaceBeauty.h
//  AFNetworking
//
//  Created by 彭蕾 on 2022/10/21.
//

#import <RCSceneNetworkKit/RCSNetworkKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSNetworkConfig (FaceBeauty)

#pragma mark - 贴纸
/// 获取贴纸
+ (RCSNetworkConfig *)getStickerProsConfig;

/// 下载贴纸对应的bundle
+ (RCSNetworkConfig *)downloadStickerConfigWith:(NSString *)itemId;

@end

NS_ASSUME_NONNULL_END
