//
//  RCSPresenter.h
//  RCSceneFaceBeautyKit_Example
//
//  Created by 彭蕾 on 2022/9/15.
//  Copyright © 2022 彭蕾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongRTCLib/RongRTCLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSPresenter : NSObject

- (void)initRTCRoom:(nullable void (^)(RCRTCRoom *_Nullable room))completion;

- (void)updateSubcribeInRoom:(RCRTCRoom *)room;

@end

NS_ASSUME_NONNULL_END
