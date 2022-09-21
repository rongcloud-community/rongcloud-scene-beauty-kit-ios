//
//  RCSBeautyEngine.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//

#import "RCSBeautyEngine.h"
#import <RongFUFaceBeautifier/RongFUFaceBeautifier.h>
#import "RCSBeautyViewController.h"
#import "RCSBeautyDefines.h"
#import "RCSBeautyEngine+Private.h"

#define RongFUBeautifier [RCRTCFUBeautyEngine sharedInstance]

@implementation RCSBeautyEngine

+ (instancetype)sharedInstance {
    static RCSBeautyEngine *engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[RCSBeautyEngine alloc] init];
    });
    return engine;
}

- (BOOL)registerWithAuthPackage:(void *)package authSize:(int)size {
    return [RongFUBeautifier registerWithAuthPackage:package authSize:size];
}

- (void)reset {
    return [RongFUBeautifier reset];
}

- (void)setBeautyEnable:(BOOL)enable {
    return [RongFUBeautifier setBeautyEnable:enable];
}

- (void)setDisplayOrientation:(int)orientation {
    return [RongFUBeautifier setDisplayOrientation:orientation];
}

- (void)setIsFrontCamera:(BOOL)front {
    return [RongFUBeautifier setIsFrontCamera:front];
}

- (void)showIn:(UIViewController *)parentVC withType:(int)type {
    [self setBeautyEnable:YES];
    [RongFUBeautifier setFaceShape:4];
    
    RCSBeautyViewController *beautyVC = [RCSBeautyViewController new];
    [parentVC addChildViewController:beautyVC];
    [parentVC.view addSubview:beautyVC.view];
    [beautyVC didMoveToParentViewController:parentVC];
}

- (void)setBeautySkin:(double)value forKey:(NSString *)key {
    ((void (^)(void))@{
        RCSBeautySkinBlurLevel : ^{
            [RongFUBeautifier setBlurIntensity:value];
        },
        RCSBeautySkinColorLevel : ^{
            [RongFUBeautifier setColorIntensity:value];
        },
        RCSBeautySkinRedLevel : ^{
            [RongFUBeautifier setRedIntensity:value];
        },
        RCSBeautySkinSharpen : ^{
            [RongFUBeautifier setSharpenIntensity:value];
        },
        RCSBeautySkinEyeBright : ^{
            [RongFUBeautifier setEyeBrightIntensity:value];
        },
        RCSBeautySkinToothWhiten : ^{
            [RongFUBeautifier setToothIntensity:value];
        },
        RCSBeautySkinRemovePouchStrength : ^{
            [RongFUBeautifier setRemovePouchIntensity:value];
        },
        RCSBeautySkinRemoveNasolabialFoldsStrength : ^{
            [RongFUBeautifier setRemoveLawPatternIntensity:value];
        },
    }[key] ?: ^{
        NSLog(@"default");
    })();
}

- (void)setBeautyShape:(double)value forKey:(NSString *)key {
    ((void (^)(void))@{
        RCSBeautyShapeCheekThinning : ^{
            [RongFUBeautifier setCheekThinningIntensity:value];
        },
        RCSBeautyShapeCheekV : ^{
            [RongFUBeautifier setCheekVIntensity:value];
        },
        RCSBeautyShapeCheekNarrow : ^{
            [RongFUBeautifier setCheekNarrowIntensity:value];
        },
        RCSBeautyShapeCheekSmall : ^{
            [RongFUBeautifier setCheekSmallIntensity:value];
        },
        RCSBeautyShapeIntensityCheekbones : ^{
            [RongFUBeautifier setCheekBonesIntensity:value];
        },
        RCSBeautyShapeIntensityLowerJaw : ^{
            [RongFUBeautifier setLowerJawIntensity:value];
        },
        RCSBeautyShapeEyeEnlarging : ^{
            [RongFUBeautifier setEyeEnlargingIntensity:value];
        },
        RCSBeautyShapeEyeCircle : ^{
            [RongFUBeautifier setEyeCircleIntensity:value];
        },
        RCSBeautyShapeIntensityChin : ^{
            [RongFUBeautifier setChinIntensity:value];
        },
        RCSBeautyShapeIntensityForehead : ^{
            [RongFUBeautifier setForeheadIntensity:value];
        },
        RCSBeautyShapeIntensityNose : ^{
            [RongFUBeautifier setNoseIntensity:value];
        },
        RCSBeautyShapeIntensityMouth : ^{
            [RongFUBeautifier setMouthIntensity:value];
        },
        RCSBeautyShapeIntensityCanthus : ^{
            [RongFUBeautifier setCanthusIntensity:value];
        },
        RCSBeautyShapeIntensityEyeSpace : ^{
            [RongFUBeautifier setEyeSpaceIntensity:value];
        },
        RCSBeautyShapeIntensityEyeRotate : ^{
            [RongFUBeautifier setEyeRotateIntensity:value];
        },
        RCSBeautyShapeIntensityLongNose : ^{
            [RongFUBeautifier setLongNoseIntensity:value];
        },
        RCSBeautyShapeIntensityPhiltrum : ^{
            [RongFUBeautifier setPhiltrumIntensity:value];
        },
        RCSBeautyShapeIntensitySmile : ^{
            [RongFUBeautifier setSmileIntensity:value];
        }
    }[key] ?: ^{
        NSLog(@"default");
    })();
}

- (void)setBeautyFilter:(double)value forKey:(NSString *)key {
    [RongFUBeautifier setFilterWithName:key level:value];
}


@end
