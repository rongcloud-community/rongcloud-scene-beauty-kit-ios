//
//  RCSBeautyModel.m
//  Pods-RCSceneFaceBeautyKit_Example
//
//  Created by 彭蕾 on 2022/9/15.
//

#import "RCSBeautyModel.h"

@implementation RCSBeautyModel

- (id)copyWithZone:(NSZone *)zone
{
    return [self yy_modelCopy];
}


- (NSString *)description {
    return [self yy_modelDescription];
}

@end
