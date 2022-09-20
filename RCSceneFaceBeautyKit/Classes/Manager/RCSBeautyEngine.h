//
//  RCSBeautyEngine.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/9/16.
//
// FURenderKit 不支持 bitcode 和 模拟器架构

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSBeautyEngine : NSObject

/*!
 美颜引擎单例
 请确保在设置美颜和滤镜之前已经初始化 RCRTCEngine 引擎。

 @remarks RCSceneFaceBeautyKit
 */
+ (instancetype)sharedInstance;

/**
 注册相芯美颜接口

 @param package 密钥数组，必须配置好密钥，SDK 才能正常工作
 @param size 密钥数组大小
 @return 初始化结果，YES-成功，NO-失败
 @remarks RCSceneFaceBeautyKit
 */
- (BOOL)registerWithAuthPackage:(void *)package authSize:(int)size;

/*!
 重置所有美颜效果
 
 @discussion 执行此方法后，会重置所有美颜美形效果，并释放素材和模型资源，但不会关闭美颜以及释放美颜引擎。
 @remarks RCSceneFaceBeautyKit
 */
- (void)reset;

/*!
 开启或者关闭美颜
 
 @param enable YES/NO 是否开启美颜 默认关闭
 @discussion 此处为总开关，设置关闭时给美颜引擎传递任何参数都不生效
 @remarks RCSceneFaceBeautyKit
 */
- (void)setBeautyEnable:(BOOL)enable;

/*!
 设置显示角度
 
 @param orientation 取值范围 0～3，对应 0～270
 @remarks RCSceneFaceBeautyKit
 */
- (void)setDisplayOrientation:(int)orientation;

/*!
 设置是否前置摄像头
 
 @param front YES/NO 是否前置摄像头
 @discussion 注意，此接口要在切换摄像头时调用
 @remarks RCSceneFaceBeautyKit
 */
- (void)setIsFrontCamera:(BOOL)front;

/*!
 显示美颜kit
 
 @param parentVC 视图控制器
 @param type 0：美颜
 @discussion 仅支持在vc中展示
 @remarks RCSceneFaceBeautyKit
 */
- (void)showIn:(UIViewController *)parentVC withType:(int)type;

@end

NS_ASSUME_NONNULL_END
