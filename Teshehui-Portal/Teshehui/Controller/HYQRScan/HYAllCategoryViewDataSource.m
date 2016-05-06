//
//  HYAllCategoryViewDataSource.m
//  Teshehui
//
//  Created by Kris on 15/6/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAllCategoryViewDataSource.h"
#import "HYMerchantCategoryCell.h"
#import "UIColor+hexColor.h"

@interface HYAllCategoryViewDataSource()


@end

@implementation HYAllCategoryViewDataSource

#pragma mark getter and setter
- (NSMutableArray *)categoryItems
{
    if (!_categoryItems)
        {
            _categoryItems = (id)[NSMutableArray array];
        }
    return _categoryItems;
}

-(NSMutableArray *)sortItems
{
    if (!_sortItems)
    {
        _sortItems = [NSMutableArray array];
        NSArray *array = [NSArray arrayWithObjects:@"智能排序", @"最新发布" ,@"离我最近", nil];
        [_sortItems addObjectsFromArray:array];
    }
    return _sortItems;
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filterType == 0)
    {
        if (tableView == _allCategorySelectTableView)
        {
            return self.categoryItems.count + 1;
        }
        else
        {
            return self.secondLevelItems.count;
        }
    }
    else
    {
        return self.sortItems.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"filter";
    HYMerchantCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[HYMerchantCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:ID];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        cell.textLabel.textColor = [UIColor colorWithHexColor:@"666666" alpha:1.0];
    }
    
    if (self.filterType == 0)
    {
        if (tableView == _allCategorySelectTableView)
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"全部分类";
                cell.merchantCountLabel.text = nil;
            }
            else
            {
                cell.textLabel.text = [self.categoryItems[indexPath.row-1] category_name];
                cell.merchantCountLabel.text = nil;
            }
            return cell;
        }
        else
        {
            if (indexPath.row == 0)
            {
                cell.textLabel.text = @"全部";
                cell.merchantCountLabel.text = [self.secondLevelItems[indexPath.row] merchantNumber];
            }
            else
            {
                cell.textLabel.text = [self.secondLevelItems[indexPath.row] category_name];
                cell.merchantCountLabel.text = [self.secondLevelItems[indexPath.row] merchantNumber];
            }
            return cell;
        }
        
    }else
    {
        cell.textLabel.text = self.sortItems[indexPath.row];
        return cell;
    }
}



@end
