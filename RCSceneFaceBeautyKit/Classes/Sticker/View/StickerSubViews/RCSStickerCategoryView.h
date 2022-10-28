//
//  RCSStickerCategoryView.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RCSStickerCategoryViewDelegate <NSObject>

- (void)toggleCategoryIndex:(NSInteger)index;

- (void)cancelSticker;

@end

@interface RCSStickerCategoryView : UIView

@property (nonatomic, weak) id<RCSStickerCategoryViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)setTitles:(NSArray<NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
