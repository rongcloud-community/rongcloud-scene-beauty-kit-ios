//
//  RCSBeautyRenderConfig.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSBeautyRenderConfig : NSObject

/// 当前图片是否来源于前置摄像头，默认为 NO
@property (nonatomic, assign) BOOL isFromFrontCamera;

/// 贴纸水平镜像，默认为 NO
@property (nonatomic, assign) BOOL stickerFlipH;

@end

NS_ASSUME_NONNULL_END
