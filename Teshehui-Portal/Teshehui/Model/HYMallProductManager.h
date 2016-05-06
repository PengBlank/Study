//
//  PTWeiboMatchManager.h
//  ContactHub
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYMallProductCellData.h"

@interface HYMallProductManager : NSObject

- (id)initWithMatchObjs:(NSArray *)matchObj;
- (void)addMatchObjs:(NSArray *)matchObj;
- (NSInteger)section;
- (void)removeAllObject;

- (HYMallProductCellData *)objectAtIndex:(NSInteger)index;

@end
