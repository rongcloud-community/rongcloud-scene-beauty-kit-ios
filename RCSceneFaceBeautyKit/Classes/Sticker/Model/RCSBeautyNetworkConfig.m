//
//  RCSBeautyNetworkConfig.m
//  RCSceneFaceBeautyKit
//
//  Created by 彭蕾 on 2022/10/21.
//

#import "RCSBeautyNetworkConfig.h"
#import "RCSBeautyEngine.h"

@implementation RCSBeautyNetworkConfig

- (instancetype)init {
    if (self = [super init]) {
        self.baseUrl = @"";
        self.businessToken = @"";
        self.auth = @"";
    }
    return self;
}

+ (NSString *)baseUrl {
    if (![RCSBeautyEngine sharedInstance].dataSource ||
        ![[RCSBeautyEngine sharedInstance].dataSource respondsToSelector:@selector(customBeautyNetworkConfig)]) {
        return @"";
    }
    
    RCSBeautyNetworkConfig *config = [[RCSBeautyEngine sharedInstance].dataSource customBeautyNetworkConfig];
    return config.baseUrl;
    
}

+ (NSString *)businessToken {
    if (![RCSBeautyEngine sharedInstance].dataSource ||
        ![[RCSBeautyEngine sharedInstance].dataSource respondsToSelector:@selector(customBeautyNetworkConfig)]) {
        return @"";
    }
    
    RCSBeautyNetworkConfig *config = [[RCSBeautyEngine sharedInstance].dataSource customBeautyNetworkConfig];
    return config.businessToken;
}

+ (NSString *)auth {
    if (![RCSBeautyEngine sharedInstance].dataSource ||
        ![[RCSBeautyEngine sharedInstance].dataSource respondsToSelector:@selector(customBeautyNetworkConfig)]) {
        return @"";
    }
    
    RCSBeautyNetworkConfig *config = [[RCSBeautyEngine sharedInstance].dataSource customBeautyNetworkConfig];
    return config.auth;
}

@end
