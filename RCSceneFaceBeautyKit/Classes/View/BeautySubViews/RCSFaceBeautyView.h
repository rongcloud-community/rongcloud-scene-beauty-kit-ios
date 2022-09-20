//
//  RCSFaceBeautyView.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import <UIKit/UIKit.h>
#import "RCSBeautyModel.h"

NS_ASSUME_NONNULL_BEGIN
@class RCSFaceBeautyView;
@protocol RCSFaceBeautyViewDelegate <NSObject>

- (void)faceBeautyViewDidRecover:(RCSFaceBeautyView *)view;
- (void)faceBeautyView:(RCSFaceBeautyView *)view didSelectedIndex:(NSInteger)index;

@end

@interface RCSFaceBeautyView : UIView

@property (nonatomic, strong) NSArray<RCSBeautyModel *> *dataArray;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, weak) id<RCSFaceBeautyViewDelegate> delegate;
/// 0: 美肤 1: 美型 
@property (nonatomic, assign) int type;

- (void)setRecoverEnable:(BOOL)enable;
- (void)reloadData;

@end


@interface RCSFaceBeautyCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
NS_ASSUME_NONNULL_END
