//
//  RCRTCConstant.m
//  RCRTCQuickDemo
//
//  Copyright © 2021 RongCloud. All rights reserved.
//

#import "Constant.h"

/*!
 填写信息之后可删除 #error
 */
@implementation Constant

// #error 请填写 App Key
/*!
 获取地址: https://developer.rongcloud.cn/app/appkey/
 */
#error 请先设置AppKey
NSString *const AppKey = @"";

// #error 请填写 App Secret
/*!
 获取Token 需要提供 App Key 和 App Secret
 正式环境请勿在客户端请求 Token，您的客户端代码一旦被反编译，会导致您的 AppSecret 泄露。
 请务必确保在服务端获取 Token。 参考文档：https://docs.rongcloud.cn/v4/views/im/server/user/register.html
 */
#error 请先设置AppSecret
NSString *const AppSecret = @"";


/// 获取 Token 接口，是使用融云即时通讯或者实时音视频，都必须要调用的接口，也是开发者服务端 唯一必须要调用的接口。
NSString *const RequestTokenURL = @"http://api-cn.ronghub.com/user/getToken.json";

@end
