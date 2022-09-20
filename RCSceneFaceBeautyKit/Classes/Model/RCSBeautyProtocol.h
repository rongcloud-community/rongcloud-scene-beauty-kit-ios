//
//  RCSBeautyProtocol.h
//  Pods
//
//  Created by 彭蕾 on 2022/9/15.
//

@protocol RCSBeautyProtocol <NSObject>

/// 0: 美肤 1: 美型 2:滤镜
@property (nonatomic, assign) int type;

/// 所属 key
@property (nonatomic, copy) NSString *key;

/// 当前值
@property (nonatomic, assign) float value;

/// 名称
@property (nonatomic, copy) NSString *title;


@end
