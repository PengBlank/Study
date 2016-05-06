//
//  HYDataManager.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDataManager : NSObject

+ (instancetype)sharedManager;

- (void)queryNewRedpacketCount:(void (^)(NSInteger newCount))callback
                   needRefresh:(BOOL)refresh;

- (void)queryCartCount:(void (^)(NSInteger count))callback needRefresh:(BOOL)refresh;

@end
