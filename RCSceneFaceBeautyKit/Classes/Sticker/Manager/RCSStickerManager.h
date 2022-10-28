//
//  RCSStickerManager.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import <Foundation/Foundation.h>
#import "RCSStickerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RCSStickerManager : NSObject

+ (instancetype)shareManager;

- (void)fetchAllSticksWithCompletion:(void (^)(NSArray<RCSStickerCategoryModel *> * _Nullable categories))completion;

- (void)downloadItem:(RCSStickerModel *)model completion:(void (^)(NSError * _Nullable error))completion;

- (void)cancelDownloadingTasks;

- (void)loadItem:(RCSStickerModel *)model;

- (void)releaseItem;

- (BOOL)downloadStatusOfSticker:(RCSStickerModel *)sticker;

- (RCSStickerModel * _Nullable)currentSelectedItem;

@end

NS_ASSUME_NONNULL_END
