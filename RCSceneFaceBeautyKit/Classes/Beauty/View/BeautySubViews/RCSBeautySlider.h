//
//  RCSBeautySlider.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSBeautySlider : UISlider

/// 零点是否在中间，默认为NO
@property (nonatomic, assign, getter=isBidirection) BOOL bidirection;

@end

NS_ASSUME_NONNULL_END
