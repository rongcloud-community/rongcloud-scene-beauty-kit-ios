//
//  RCSStickerModel.m
//  RCSceneFaceBeautyKit-RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/17.
//

#import "RCSStickerModel.h"

@implementation RCSStickerModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"type"  : @"category",
             @"imgUrl"  : @"previewImgPath",
             @"itemId": @[@"id"]};
}

@end

@implementation RCSStickerCategoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [RCSStickerModel class] };
}

@end
