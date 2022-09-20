//
//  RCSBeautyManager.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/15.
//

#import "RCSBeautyManager.h"
#import "RCSPersistentBeautyModel.h"
#import <YYModel/YYModel.h>
#import "RCSBeautyDefines.h"
#import "RCSBeautyEngine.h"
#import "RCSBeautyEngine+Private.h"

@interface RCSBeautyManager ()

@property (nonatomic, strong, readwrite) RCSPersistentBeautyModel *beautyModel;

@end

@implementation RCSBeautyManager

+ (instancetype)shareManager {
    static RCSBeautyManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[RCSBeautyManager alloc] init];
        _manager.filterChoice = -1;
    });
    return _manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.beautyModel = [self loadBeautyModel];
    }
    return self;
}

#pragma mark - public method

/// 是否完全使用默认参数
- (BOOL)isDefaultValue:(int)type {
    switch (type) {
        case 0:
            return [self isDefaultSkinValue];
            
        case 1:
            return [self isDefaultShapeValue];
            
        default:
            break;
    }
    return YES;
}

- (BOOL)isDefaultSkinValue {
    for (RCSBeautyModel *model in self.beautyModel.beautySkins) {
        if (fabs(model.value - model.defaultValue) > 0.01) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isDefaultShapeValue {
    for (RCSBeautyModel *model in self.beautyModel.beautyShapes) {
        if (fabs(model.value - model.defaultValue) > 0.01) {
            return NO;
        }
    }
    return YES;
}

- (void)resetBeautySkinValue {
    for (RCSBeautyModel *model in self.beautyModel.beautySkins) {
        model.value = model.defaultValue;
        [[RCSBeautyEngine sharedInstance] setBeautySkin:model.value forKey:model.key];
    }
}

- (void)resetBeautyShapeValue {
    for (RCSBeautyModel *model in self.beautyModel.beautyShapes) {
        model.value = model.defaultValue;
        [[RCSBeautyEngine sharedInstance] setBeautyShape:model.value forKey:model.key];
    }
}

#pragma mark - load data
- (RCSPersistentBeautyModel *)loadBeautyModel {
    RCSPersistentBeautyModel *model = [RCSPersistentBeautyModel new];
    model.beautySkins = [self loadBeautySkins];
    model.beautyShapes = [self loadBeautyShapes];
    model.beautyFilters = [self loadBeautyFilters];
    return model;
}

- (NSArray<RCSBeautyModel *> *)loadBeautySkins {
    NSString *path = [[self sourceBundle] pathForResource:@"beautySkins" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *skinParams = [NSMutableArray array];
    for (NSDictionary *data in arr) {
        RCSBeautyModel *model = [RCSBeautyModel yy_modelWithJSON:data];
        model.defaultValue = model.value;
        model.ratio = ([model.key isEqualToString:RCSBeautySkinBlurLevel]) ? 6.0 : 1.0;

        [skinParams addObject:model];
    }
    return [NSArray arrayWithArray:skinParams];
}

- (NSArray<RCSBeautyModel *> *)loadBeautyShapes {
    NSString *path = [[self sourceBundle] pathForResource:@"beautyShapes" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *shapeParams = [NSMutableArray array];
    for (NSDictionary *data in arr) {
        RCSBeautyModel *model = [RCSBeautyModel yy_modelWithJSON:data];
        model.defaultValue = model.value;
        model.ratio = 1.0;
        model.isStyle101 = [[self style101Key] containsObject:model.key];
        [shapeParams addObject:model];
    }
    return [NSArray arrayWithArray:shapeParams];
}

- (NSArray<NSString *> *)style101Key {
    return @[
        RCSBeautyShapeIntensityChin,
        RCSBeautyShapeIntensityForehead,
        RCSBeautyShapeIntensityMouth,
        RCSBeautyShapeIntensityEyeSpace,
        RCSBeautyShapeIntensityEyeRotate,
        RCSBeautyShapeIntensityLongNose,
        RCSBeautyShapeIntensityPhiltrum,
        RCSBeautyShapeIntensityBrowHeight,
        RCSBeautyShapeIntensityBrowSpace
    ];
}

- (NSArray<RCSBeautyModel *> *)loadBeautyFilters {
    NSString *path = [[self sourceBundle] pathForResource:@"beautyFilters" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *filterParams = [NSMutableArray array];
    for (NSDictionary *data in arr) {
        RCSBeautyModel *model = [RCSBeautyModel yy_modelWithJSON:data];
        model.defaultValue = model.value;
        model.ratio = 1.0;
        [filterParams addObject:model];
    }
    return [NSArray arrayWithArray:filterParams];
}

- (NSBundle *)sourceBundle {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:RCSBeautyBundleName withExtension:@"bundle"];
    if (!bundleURL) {
        // use_frameworks
        bundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        bundleURL = [bundleURL URLByAppendingPathComponent:RCSBeautyBundleName];
        bundleURL = [bundleURL URLByAppendingPathExtension:@"framework"];
        NSBundle *associateBundle = [NSBundle bundleWithURL:bundleURL];
        bundleURL = [associateBundle URLForResource:RCSBeautyBundleName withExtension:@"bundle"];
    }

    return [NSBundle bundleWithURL:bundleURL];
}

@end
