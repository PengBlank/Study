//
//  PTWeiboMatchCellData.m
//  ContactHub
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#import "HYMallProductCellData.h"

@interface HYMallProductCellData ()

@property (nonatomic, retain) NSMutableArray *rowDatas;

@end

@implementation HYMallProductCellData

- (void)dealloc
{

}

- (id)initWithRowObjs:(NSArray *)rowDatas
{
    self = [super init];
    
    if (self)
    {
        self.rowDatas = [NSMutableArray arrayWithArray:rowDatas];
    }
    
    return self;
}

- (void)addObject:(id)obj
{
    if (obj)
    {
        [self.rowDatas addObject:obj];
    }
}

- (void)addObjectFromArray:(NSArray *)array
{
    if (array)
    {
        [self.rowDatas addObjectsFromArray:array];
    }
}

- (id)objectAtRow:(NSUInteger)row
{
    if (row < [self.rowDatas count])
    {
        return [self.rowDatas objectAtIndex:row];
    }
    
    return nil;
}

- (NSUInteger)count
{
    return [self.rowDatas count];
}

@end
