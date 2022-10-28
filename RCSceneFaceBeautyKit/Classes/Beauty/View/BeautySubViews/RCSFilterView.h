//
//  RCSFilterView.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import <UIKit/UIKit.h>
#import "RCSBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol RCSFilterViewDelegate <NSObject>

- (void)filterViewDidSelectedIndex:(NSInteger)index;

@end


@interface RCSFilterView : UICollectionView

@property (nonatomic, strong) NSArray<RCSBeautyModel *> *filters;
@property (nonatomic, weak) id<RCSFilterViewDelegate> customDelegate;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@interface RCSFilterCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
