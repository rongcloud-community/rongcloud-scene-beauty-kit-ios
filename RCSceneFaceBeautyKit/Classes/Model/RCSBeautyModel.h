//
//  RCSBeautyModel.h
//  Pods-RCSceneFaceBeautyKit_Example
//
//  Created by 彭蕾 on 2022/9/15.
//

#import <Foundation/Foundation.h>
#import "RCSBeautyProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface RCSBeautyModel : NSObject <RCSBeautyProtocol, NSCopying>

/// 0: 美肤 1: 美型 2:滤镜
@property (nonatomic, assign) int type;

/// 所属 key
@property (nonatomic, copy) NSString *key;

/// 当前值
@property (nonatomic, assign) float value;

/// 名称
@property (nonatomic, copy) NSString *title;

/// 默认值
@property (nonatomic, assign) float defaultValue;

/// 双向的参数  0.5是原始值
@property (nonatomic, assign) BOOL isStyle101;

/// 参数强度取值比例 进度条因为是归一化 所以要除以ratio
@property (nonatomic, assign) float ratio;

@end

NS_ASSUME_NONNULL_END
