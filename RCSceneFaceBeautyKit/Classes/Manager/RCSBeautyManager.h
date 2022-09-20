//
//  RCSBeautyManager.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/15.
//

#import <Foundation/Foundation.h>
#import "RCSPersistentBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSBeautyManager : NSObject

@property (nonatomic, strong, readonly) RCSPersistentBeautyModel *beautyModel;

@property (nonatomic, assign) NSInteger filterChoice;

+ (instancetype)shareManager;

/// 是否完全使用默认参数
- (BOOL)isDefaultValue:(int)type;

/// 恢复默认美肤
- (void)resetBeautySkinValue;

/// 恢复默认美型
- (void)resetBeautyShapeValue;

@end

NS_ASSUME_NONNULL_END
