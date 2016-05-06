//
//  HYHomeStore.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/15.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 首页数据缓存
 *  缓存策略：进入首页时直接取出缓存数据（如果有的话），然后调用接口获取数据。
 *  如果获取到网络数据，显示网络数据并且刷新缓存，如果没有获取到网络数据，则仅显示缓存数据并用提示网络错误
 */
@interface HYHomeStore : NSObject

+ (void)cacheHomeItems:(NSArray*)items;
+ (NSArray *)getCachedItems;

@end
