//
//  LocalCityManager.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalCityManager : NSObject

+ (instancetype)sharedManager;

//状态信息
@property (nonatomic, strong) NSString *city;


@end
