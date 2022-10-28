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
#import <FURenderKit/FURenderKit.h>
#import <FURenderKit/FUQualitySticker.h>
#import <FURenderKit/FUSticker.h>
#import "RCSStickerViewController.h"
#import "RCSStickerManager.h"

#define RongFUBeautifier [RCRTCFUBeautyEngine sharedInstance]
#define RongFUSticker [FURenderKit shareRenderKit].stickerContainer

@interface RCSBeautyEngine ()

@property (nonatomic, strong) FUSticker *currentSticker;

@end

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
    BOOL result = [RongFUBeautifier registerWithAuthPackage:package authSize:size];
    if (result) {
        // 加载手势 AI 模型，bundle必须与版本对应
        NSString *handAIPath = [[NSBundle mainBundle] pathForResource:@"ai_hand_processor" ofType:@"bundle"];
        [FUAIKit loadAIModeWithAIType:FUAITYPE_HANDPROCESSOR dataPath:handAIPath];
        [FUAIKit shareKit].maxTrackFaces = 4;
    }
    return result;
}

- (void)reset {
    return [RongFUBeautifier reset];
}

- (void)setBeautyEnable:(BOOL)enable {
    return [RongFUBeautifier setBeautyEnable:enable];
}

- (void)clearStickers {
    [[RCSStickerManager shareManager] releaseItem];
}

- (void)showIn:(UIViewController *)parentVC withType:(int)type {
    [self setBeautyEnable:YES];
    [RongFUBeautifier setFaceShape:4];
    
    switch (type) {
        case 0: { /// 美颜
            RCSBeautyViewController *beautyVC = [RCSBeautyViewController new];
            [parentVC addChildViewController:beautyVC];
            [parentVC.view addSubview:beautyVC.view];
            [beautyVC didMoveToParentViewController:parentVC];
        }
            break;
        case 1: { /// 贴纸
            RCSStickerViewController *stickerVC = [RCSStickerViewController new];
            [parentVC addChildViewController:stickerVC];
            [parentVC.view addSubview:stickerVC.view];
            [stickerVC didMoveToParentViewController:parentVC];
        }
            
        default:
            break;
    }
    
}

#pragma mark - PRIVATE METHOD -
#pragma mark - 美颜
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

#pragma mark - 贴纸
- (void)removeAllSticker {
    self.currentSticker = nil;
    [RongFUSticker removeAllSticks];
}

- (void)addStickerWithPath:(NSString *)path name:(NSString *)name completion:(nullable void(^)(void))completion {
    FUSticker *sticker = [[FUSticker alloc] initWithPath:path name:name];
    if (self.currentSticker) {
        [RongFUSticker replaceSticker:self.currentSticker withSticker:sticker completion:completion];
    } else {
        [RongFUSticker addSticker:sticker completion:completion];
    }
    self.currentSticker = sticker;
}

@end
