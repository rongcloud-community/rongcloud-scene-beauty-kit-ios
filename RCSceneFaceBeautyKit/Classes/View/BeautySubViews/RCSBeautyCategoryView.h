//
//  RCSBeautyCategoryView.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RCSBeautyCategoryViewDelegate <NSObject>

- (void)toggleCategoryIndex:(NSInteger)index;

@end

@interface RCSBeautyCategoryView : UIView

@property (nonatomic, weak) id<RCSBeautyCategoryViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
