//
//  SKSTableView.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import <objc/runtime.h>

#pragma mark - NSArray (SKSTableView)

@interface NSMutableArray (SKSTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems;

@end

@implementation NSMutableArray (SKSTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems
{
    for (NSInteger index = [self count]; index < numItems; index++) {
        NSMutableArray *array = [NSMutableArray array];
        [self addObject:array];
    }
}

@end

#pragma mark - SKSTableView


@interface SKSTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *expandedIndexPaths;

@property (nonatomic, strong) NSMutableDictionary *expandableCells;

@end

@implementation SKSTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    
    return self;
}

- (void)setSKSTableViewDelegate:(id<SKSTableViewDelegate>)SKSTableViewDelegate
{
    self.dataSource = self;
    self.delegate = self;
    
    if (SKSTableViewDelegate)
        _SKSTableViewDelegate = SKSTableViewDelegate;
}

/**
 *  已展开的cell表，记录哪些path是展开cell，展开或收起时更新
 *  _expandedIndexPath[section] = @[1, 2, 3]表示该table的第一、二、三列均是展开列
 */
- (NSMutableArray *)expandedIndexPaths
{
    if (!_expandedIndexPaths)
        _expandedIndexPaths = [NSMutableArray array];
    
    return _expandedIndexPaths;
}

//key: indexpath, value: bool, yes or not.指明是否可展开
- (NSMutableDictionary *)expandableCells
{
    if (!_expandableCells)
        _expandableCells = [NSMutableDictionary dictionary];
    
    return _expandableCells;
}

#pragma mark - UITableViewDataSource

#pragma mark - Required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_SKSTableViewDelegate tableView:tableView numberOfRowsInSection:section] + [[[self expandedIndexPaths] objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath])
    {
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
        {
            return [_SKSTableViewDelegate tableView:tableView heightForRowAtIndexPath:[self correspondingIndexPathForRowAtIndexPath:indexPath]];
        }
    }
    else
    {
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForSubRowAtIndexPath:)])
        {
            return [_SKSTableViewDelegate tableView:tableView heightForSubRowAtIndexPath:[self correspondingIndexPathForSubRowAtIndexPath:indexPath]];
        }
    }
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //展开项cell
    if ([_expandedIndexPaths[indexPath.section] containsObject:indexPath])
    {
        NSIndexPath *indexPathForSubrow = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        UITableViewCell *cell = [_SKSTableViewDelegate tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:indexPathForSubrow];
        return cell;
    }//非展开项cell
    else
    {
        NSIndexPath *cpath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
        SKSTableViewCell *cell = (SKSTableViewCell *)[_SKSTableViewDelegate tableView:tableView cellForRowAtIndexPath:cpath];
        
        if ([[self.expandableCells allKeys] containsObject:cpath])
        {
            [cell setIsExpanded:[[self.expandableCells objectForKey:cpath] boolValue]];
        }
        else
        {
            cell.isExpanded = NO;
        }
//        else if (cell.isExpandable)
//        {
//            [self.expandableCells setObject:[NSNumber numberWithBool:NO]
//                                     forKey:cpath];
//        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        return cell;
    }
}

#pragma mark - Optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 0;
    if ([_SKSTableViewDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)])
    {
        numberOfSections = [_SKSTableViewDelegate numberOfSectionsInTableView:tableView];
    }
    else
    {
        numberOfSections = 1;
    }
    if ([self.expandedIndexPaths count] != numberOfSections)
    {
        [self.expandedIndexPaths initiateObjectsForCapacity:numberOfSections];
    }
    return numberOfSections;
}

#pragma mark - UITableViewDelegate

#pragma mark - Optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是一级cell
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath])
    {
        
        SKSTableViewCell *cell = (SKSTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSIndexPath *cpath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[SKSTableViewCell class]] && cell.isExpandable)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger numberOfSubRows = [_SKSTableViewDelegate tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:cpath];
            NSMutableArray *indexPaths = [NSMutableArray array];
            NSInteger row = indexPath.row;
            NSInteger section = indexPath.section;
            
            for (NSInteger index = 1; index <= numberOfSubRows; index++)
            {
                NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row+index inSection:section];
                [indexPaths addObject:expIndexPath];
            }
            //已闭合，展开
            if (!cell.isExpanded)
            {
                [_expandableCells setObject:[NSNumber numberWithBool:YES] forKey:cpath];
                cell.isExpanded = YES;
                if (indexPaths.count > 0)
                {
                    [self insertExpandedIndexPaths:indexPaths forSection:indexPath.section];
                    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                }
                
            }//展开，闭合
            else
            {
                [_expandableCells setObject:[NSNumber numberWithBool:NO] forKey:cpath];
                cell.isExpanded = NO;
                if (indexPaths.count > 0)
                {
                    [self removeExpandedIndexPaths:indexPaths forSection:indexPath.section];
                    for (NSIndexPath* path in indexPaths) {
                        UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
                        cell.hidden = YES;
                    }
                    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }
        
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [_SKSTableViewDelegate tableView:tableView didSelectRowAtIndexPath:cpath];
        }
    }
    else
    {
    //二级cell
        NSIndexPath *indexPathForSubrow = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
            [_SKSTableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPathForSubrow];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [_SKSTableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - SKSTableViewUtils

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:[self correspondingIndexPathForRowAtIndexPath:indexPath]];
}

//由原始path得到转换后的path
- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = 0;
    NSUInteger row = 0;
    
    while (index < indexPath.row)
    {
        NSIndexPath *getIndexPath = [NSIndexPath indexPathForRow:row
                                                       inSection:indexPath.section];
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:getIndexPath] ? [[self.expandableCells objectForKey:getIndexPath] boolValue] : NO;
        
        if (isExpanded)
        {
            NSInteger numberOfExpandedRows = [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:getIndexPath];
            
            index += ((NSUInteger)numberOfExpandedRows + 1);
            
        } else
            index++;
        
        row++;
        
    }
    
    return [NSIndexPath indexPathForRow:row inSection:indexPath.section];
}

- (NSIndexPath *)correspondingIndexPathForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    NSInteger row = 0;
    NSInteger subrow = 0;
    
    while (index < indexPath.row)
    {
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tempIndexPath] ? [[self.expandableCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded)
        {
            NSInteger numberOfExpandedRows = [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
            if ((indexPath.row - index) <= numberOfExpandedRows) {
                subrow = indexPath.row - index;
                break;
            }
            
            index += (numberOfExpandedRows + 1);
            
        } else
            index++;
        
        row++;
    }
    
    return [NSIndexPath indexPathForSubRow:subrow inRow:row inSection:indexPath.section];
}


//TODO: 暂时未用到，注释掉了subrow的偏移，这个方法不一定正确
- (NSIndexPath *)originPathForConvertedPath:(NSIndexPath *)oPath
{
    @throw [NSException exceptionWithName:@"方法不一定正角" reason:nil userInfo:nil];
    NSInteger idx = 0;
    NSInteger row = 0;
    while (row < oPath.row)
    {
        NSIndexPath *tmpPath = [NSIndexPath indexPathForRow:row inSection:oPath.section];
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tmpPath] ? [[self.expandableCells objectForKey:tmpPath] boolValue] : NO;
        if (isExpanded) {
            NSInteger numberOfExpandedRows = [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tmpPath];
            idx += (numberOfExpandedRows + 1);
        } else {
            idx ++;
        }
        row ++;
    }
    
    idx += oPath.subrow - 1;
    return [NSIndexPath indexPathForRow:idx inSection:oPath.section];
}

/**
 *  插入展开项
 *
 *  @param indexPaths 展开的indexPath
 *  @param section    展开的section
 *
 *  只要比需展开行第一行大的行，都需要后移
 */
- (void)insertExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section
{
    NSIndexPath *firstIndexPathToExpand = indexPaths[0];
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *old = self.expandedIndexPaths[section];
    for (NSInteger i = 0; i < old.count; i++)
    {
        NSIndexPath *exist = [old objectAtIndex:i];
        if (exist.row > firstIndexPathToExpand.row)
        {
            NSIndexPath *update = [NSIndexPath indexPathForRow:exist.row+indexPaths.count
                                                     inSection:exist.section];
            [array addObject:update];
        }
        else
        {
            [array addObject:exist];
        }
    }
    [array addObjectsFromArray:indexPaths];
    
    self.expandedIndexPaths[section] = array;
    [self sortExpandedIndexPathsForSection:section];
}

/**
 *  移除展开项
 *
 *  @param indexPaths 需移除的indexPaths
 *  @param section    移除section
 */
- (void)removeExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section
{
    NSUInteger index = [self.expandedIndexPaths[section] indexOfObject:indexPaths[0]];
    
    [self.expandedIndexPaths[section] removeObjectsInArray:indexPaths];
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *old = self.expandedIndexPaths[section];
    for (NSInteger i = 0; i < old.count; i++)
    {
        NSIndexPath *obj = [old objectAtIndex:i];
        if (i < index)
        {
            NSIndexPath *exist = obj;
            [array addObject:exist];
        }
        else{
            NSIndexPath *updated = [NSIndexPath indexPathForRow:([obj row] - [indexPaths count])
                                                      inSection:[obj section]];
            [array addObject:updated];
        }
    }
    
    self.expandedIndexPaths[section] = array;
    
    [self sortExpandedIndexPathsForSection:section];
}

- (void)sortExpandedIndexPathsForSection:(NSInteger)section
{
    [self.expandedIndexPaths[section]  sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        if ([obj1 section] < [obj2 section])
            return (NSComparisonResult)NSOrderedAscending;
        else if ([obj1 section] > [obj2 section])
            return (NSComparisonResult)NSOrderedDescending;
        else {
            if ([obj1 row] < [obj2 row])
                return (NSComparisonResult)NSOrderedAscending;
            else
                return (NSComparisonResult)NSOrderedDescending;
        }
    }];
}

@end

#pragma mark - NSIndexPath (SKSTableView)

static unichar subrowKey;

@implementation NSIndexPath (SKSTableView)


- (NSInteger)subrow
{
    if (self.length <= 2)
    {
        return 0;
    }
    
    return [self indexAtPosition:2];
}

- (NSInteger)row
{
    if (self.length <= 1)
    {
        return 0;
    }
    return [self indexAtPosition:1];
}

- (NSInteger)section
{
    if (self.length <= 0)
    {
        return 0;
    }
    return [self indexAtPosition:0];
}

//- (void)setSubrow:(NSInteger)subrow
//{
//    if (self.subrow != subrow)
//    {
//        id myclass = [SKSTableView class];
//
//        objc_setAssociatedObject(myclass, &subrowKey, [NSNumber numberWithInteger:subrow], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSUInteger indexes[] = { section, row, subrow };
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:indexes length:3];
    
    return indexPath;
    /*
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
     indexPath.subrow = subrow;
     return indexPath;
     */
}
@end

