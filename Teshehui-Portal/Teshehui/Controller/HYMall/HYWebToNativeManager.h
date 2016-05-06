//
//  HYWebToNativeManager.h
//  Teshehui
//
//  Created by 成才 向 on 16/2/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYWebToNativeManager : NSObject

+ (UIViewController*)checkNativeControllerWithType:(NSString *)type
                productCode:(NSString *)code
                     expand:(NSString *)expand
                    expand1:(NSString *)expand1;

+ (UIViewController *)checkWebToNativeCall:(NSString *)callParam;

@end
