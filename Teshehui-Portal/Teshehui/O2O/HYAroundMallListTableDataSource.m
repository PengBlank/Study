//
//  HYAroundMallListTableDataSource.m
//  Teshehui
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundMallListTableDataSource.h"
#import "HYAroundShopListCell.h"
#import "HYQRCodeGetShopListResponse.h"

@implementation HYAroundMallListTableDataSource

- (NSMutableArray *)items
{
    if (!_items)
    {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return _items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    HYAroundShopListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYAroundShopListCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
        
    }
    
    if (self.items.count > indexPath.section)
    {
        HYQRCodeShop *shop = [self.items objectAtIndex:indexPath.section];
        [cell setWithShop:shop];
    }
    
    return cell;
}

- (id)itemAtIndexPath:(NSIndexPath *)idxPath
{
    NSUInteger idx = (NSUInteger)idxPath.section;
    if (idx < _items.count)
    {
        return [_items objectAtIndex:idx];
    }
    return nil;
}

- (void)cleanData
{
    [self.items removeAllObjects];
}

@end
