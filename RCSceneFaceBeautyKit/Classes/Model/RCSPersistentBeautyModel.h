//
//  RCSPersistentBeautyModel.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/15.
//

#import <Foundation/Foundation.h>
#import "RCSBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSPersistentBeautyModel : NSObject

/// 美肤
@property (nonatomic, strong) NSArray<RCSBeautyModel *> *beautySkins;

/// 美型
@property (nonatomic, strong) NSArray<RCSBeautyModel *> *beautyShapes;

/// 滤镜
@property (nonatomic, strong) NSArray<RCSBeautyModel *> *beautyFilters;

@end

NS_ASSUME_NONNULL_END
