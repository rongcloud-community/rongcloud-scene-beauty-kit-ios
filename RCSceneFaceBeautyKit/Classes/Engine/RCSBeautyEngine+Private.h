//
//  RCSBeautyEngine+Private.h
//  Pods
//
//  Created by 彭蕾 on 2022/9/16.
//
#import "RCSBeautyEngine.h"

@interface RCSBeautyEngine (Private)

#pragma mark - 美颜
- (void)setBeautySkin:(double)value forKey:(NSString *)key;

- (void)setBeautyShape:(double)value forKey:(NSString *)key;

- (void)setBeautyFilter:(double)value forKey:(NSString *)key;

#pragma mark - 贴纸
- (void)removeAllSticker;

- (void)addStickerWithPath:(NSString *)path name:(NSString *)name completion:(nullable void(^)(void))completion;

@end
