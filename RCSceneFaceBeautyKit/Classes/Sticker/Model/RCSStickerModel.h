//
//  RCSStickerModel.h
//  RCSceneFaceBeautyKit-RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RCSStickerModel : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign, getter=isLoading) BOOL loading;

@end

@interface RCSStickerCategoryModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<RCSStickerModel *> *data;

@end



NS_ASSUME_NONNULL_END
