//
//  PTWeiboMatchManager.m
//  ContactHub
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#import "HYMallProductManager.h"

@interface HYMallProductManager ()
{
    NSMutableArray *_matchObjects;
}

@end

const NSUInteger scope = 2;

@implementation HYMallProductManager

- (void)dealloc
{

}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _matchObjects = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithMatchObjs:(NSArray *)matchObjs
{
    self = [super init];
    
    if (self)
    {
        _matchObjects = [[NSMutableArray alloc] init];
        [self separationWithArray:matchObjs];
    }
    
    return self;
}

- (void)addMatchObjs:(NSArray *)matchObjs
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:matchObjs];
    
    HYMallProductCellData *last = [_matchObjects lastObject];
    
    if (last && last.count < scope)
    {
        NSInteger offset = scope-last.count;
        if (offset > [temp count])
        {
            offset = [temp count];
        }
        NSArray *array = [temp subarrayWithRange:NSMakeRange(0, offset)];
        [last addObjectFromArray:array];
        [temp removeObjectsInRange:NSMakeRange(0, offset)];
    }
    
    [self separationWithArray:temp];
}

- (HYMallProductCellData *)objectAtIndex:(NSInteger)index
{
    HYMallProductCellData *data = nil;
    if (index < [_matchObjects count])
    {
        data = [_matchObjects objectAtIndex:index];
    }
    
    return data;
}

- (NSInteger)section
{
    return [_matchObjects count];
}

- (void)removeAllObject
{
    [_matchObjects removeAllObjects];
}

#pragma mark -
- (void)separationWithArray:(NSArray *)array
{
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:array];
    
    NSInteger i = 0;
    NSInteger count = [temp count];
    
    while (i < count)
    {
        NSInteger offset = scope;
        if ([temp count] < offset)
        {
            offset = [temp count];
        }
        
        NSArray *array = [temp subarrayWithRange:NSMakeRange(0, offset)];
        HYMallProductCellData *data = [[HYMallProductCellData alloc] initWithRowObjs:array];
        [_matchObjects addObject:data];

        [temp removeObjectsInRange:NSMakeRange(0, offset)];
        i += scope;
    }
    
    if ([temp count] > 0)
    {
        HYMallProductCellData *data = [[HYMallProductCellData alloc] initWithRowObjs:temp];
        [_matchObjects addObject:data];
    }
}

@end