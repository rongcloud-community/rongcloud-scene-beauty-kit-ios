//
//  RCRTCFUBeautyEngine+RCSSticker.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/19.
//

#import "RCRTCFUBeautyEngine+RCSSticker.h"
#import "RCSStickerManager.h"
#import <CoreMedia/CoreMedia.h>
#import <FURenderKit/FURenderKit.h>
#import "RCSStickerManager.h"
#import "RCSBeautyEngine.h"
#import "RCSBeautyRenderConfig.h"

@implementation RCRTCFUBeautyEngine (RCSSticker)
+ (void)load {
    [self bestMethodSwizzlingWithClass:RCRTCFUBeautyEngine.class
                                oriSEL:NSSelectorFromString(@"processFrame:")
                           swizzledSEL:@selector(rcs_processFrame:)];
}

#pragma mark - hook method
- (CMSampleBufferRef)rcs_processFrame:(CMSampleBufferRef)frameBuffer {
    if (![RCSStickerManager shareManager].currentSelectedItem) {
        
        return [self rcs_processFrame:frameBuffer];
    }
    
    if (![RCSBeautyEngine sharedInstance].dataSource ||
        ![[RCSBeautyEngine sharedInstance].dataSource respondsToSelector:@selector(customBeautyRenderConfig)]) {
        
        return [self rcs_processFrame:frameBuffer];
    }
    
    BOOL registered = [self valueForKey:@"registered"];
    BOOL beautyLoaded = [self valueForKey:@"beautyLoaded"];
    BOOL beautyEnable = [self valueForKey:@"beautyEnable"];
    if (!registered || !beautyLoaded || !beautyEnable || !frameBuffer || !CMSampleBufferIsValid(frameBuffer)) {
        return frameBuffer;
    }
    
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(frameBuffer);
    FURenderInput *renderInput = [[FURenderInput alloc] init];
    renderInput.pixelBuffer = pixelBuffer;
    renderInput.renderConfig.readBackToPixelBuffer = YES;
    
    RCSBeautyRenderConfig *config = [[RCSBeautyEngine sharedInstance].dataSource customBeautyRenderConfig];
    renderInput.renderConfig.isFromFrontCamera = config.isFromFrontCamera;
    renderInput.renderConfig.stickerFlipH = config.stickerFlipH;
    
    
    //    耗性能操作
    //    float scale = [UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height;
    //    renderInput.renderConfig.customOutputSize = CGSizeMake(1280*scale, 1280);
    //    renderInput.renderConfig.customOutputSize = config.customOutputSize;
    
    [[FURenderKit shareRenderKit] renderWithInput:renderInput];
    return frameBuffer;
}

+ (void)bestMethodSwizzlingWithClass:(Class)cls oriSEL:(SEL)oriSEL swizzledSEL:(SEL)swizzledSEL{
    if (!cls) NSLog(@"传入的交换类不能为空");
    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    if (!oriMethod) {
        class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        // IMP指向了一个空的block方法（空IMP）
        method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
    }
    
    BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else{
        method_exchangeImplementations(oriMethod, swiMethod);
    }
}

@end
