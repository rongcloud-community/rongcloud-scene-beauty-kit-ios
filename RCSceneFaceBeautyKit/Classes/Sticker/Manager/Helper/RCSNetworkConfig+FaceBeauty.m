//
//  RCSNetworkConfig+FaceBeauty.m
//  AFNetworking
//
//  Created by 彭蕾 on 2022/10/21.
//

#import "RCSNetworkConfig+FaceBeauty.h"
#import "RCSBeautyNetworkConfig.h"

@implementation RCSNetworkConfig (FaceBeauty)

+ (RCSNetworkConfig *)getStickerProsConfig {
    NSString *url = [[RCSBeautyNetworkConfig baseUrl] stringByAppendingFormat:@"%@",@"props/queryProps"];
    NSString *headers = @{
        @"BusinessToken":[RCSBeautyNetworkConfig businessToken],
        @"Authorization":[RCSBeautyNetworkConfig auth]
    };
    return [self configWithUrl:url
                  rspClassName:nil
                        method:RCSHTTPRequestMethodGET
                        params:nil
                       headers:headers];
}

+ (RCSNetworkConfig *)downloadStickerConfigWith:(NSString *)itemId {
    NSString *url = [[RCSBeautyNetworkConfig baseUrl] stringByAppendingFormat:@"props/download?id=%@",itemId];
    return [self configWithUrl:url
                  rspClassName:nil
                        method:RCSHTTPRequestMethodGET
                        params:nil
                       headers:nil];
}

@end
