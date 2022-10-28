//
//  RCSBeautyNetworkConfig.h
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCSBeautyNetworkConfig : NSObject

/// 网络请求 host
@property (nonatomic, copy) NSString *baseUrl;

/// 网络请求 header  bussinessToken
@property (nonatomic, copy) NSString *businessToken;

/// 网络请求 header 用户登录后返回的 auth
@property (nonatomic, copy) NSString *auth;

+ (NSString *)baseUrl;
+ (NSString *)businessToken;
+ (NSString *)auth;

@end

NS_ASSUME_NONNULL_END
