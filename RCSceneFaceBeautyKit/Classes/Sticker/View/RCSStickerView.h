//
//  RCSStickerView.h
//  RCSceneFaceBeautyKit-RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import <UIKit/UIKit.h>
#import "RCSStickerModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol RCSStickerViewDelegate <NSObject>

- (void)releaseSticker;

- (void)addStickerWithModel:(RCSStickerModel *)model complition:(void(^)(BOOL))complition;

@end

@interface RCSStickerView : UIView

@property (nonatomic, weak) id<RCSStickerViewDelegate> delegate;
- (void)loadFullData:(NSArray<RCSStickerCategoryModel *> *)categories;

@end

NS_ASSUME_NONNULL_END
