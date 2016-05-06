//
//  PTWeiboMatchCellData.h
//  ContactHub
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

/*
 每一行cell 的数据
 */
 
#import <Foundation/Foundation.h>

@interface HYMallProductCellData : NSObject

- (id)initWithRowObjs:(NSArray *)rowDatas;
- (void)addObject:(id)obj;
- (void)addObjectFromArray:(NSArray *)array;
- (id)objectAtRow:(NSUInteger)row;
- (NSUInteger)count;

@end
