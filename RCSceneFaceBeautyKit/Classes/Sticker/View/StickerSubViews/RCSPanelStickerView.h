//
//  RCSPanelStickerView.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import <UIKit/UIKit.h>
#import "RCSStickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@class RCSPanelStickerView;
@protocol RCSPanelStickerViewDelegate <NSObject>

- (void)panelStickerView:(RCSPanelStickerView *)panel didSelectedIndex:(NSIndexPath *)indexPath;

@end


@interface RCSPanelStickerView : UIView

@property (nonatomic, strong) NSArray<RCSStickerModel *> *dataArray;
@property (nonatomic, weak) id<RCSPanelStickerViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;

- (void)reloadData;
- (void)reloadDataWithIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
