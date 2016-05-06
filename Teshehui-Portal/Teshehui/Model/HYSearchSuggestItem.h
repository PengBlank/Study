//
//  HYSearchSuggestItem.h
//  Teshehui
//
//  Created by apple on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYSearchSuggestItem : NSObject<CQResponseResolve>

@property (nonatomic, strong) NSString *display;
@property (nonatomic, strong) NSString *matchValue;
@property (nonatomic, assign) NSInteger type;

@end
