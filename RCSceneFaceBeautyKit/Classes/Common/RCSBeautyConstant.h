//
//  RCSBeautyConstant.h
//  Pods
//
//  Created by 彭蕾 on 2022/9/16.
//

#ifndef RCSBeautyConstant_h
#define RCSBeautyConstant_h

#define RCSBeautyBundleName @"RCSceneFaceBeautyKit"
#define RCSBeautyMainColor [UIColor rcs_colorWithHex:0x5EC7FE]
#define RCSBeautyImageNamed(imageName) [UIImage rcs_imageNamed:imageName bundle:RCSBeautyBundleName]
#define RCSBeautyScreenWidth [UIScreen mainScreen].bounds.size.width

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#endif /* RCSBeautyConstant_h */
