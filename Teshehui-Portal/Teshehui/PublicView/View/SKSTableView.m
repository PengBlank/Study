//
//  SKSTableView.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "SKSTableView.h"
#import "SKSTableViewCell.h"
#import "SKSTableViewCellIndicator.h"
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

#pragma mark - Scroll view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.SKSTableViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.SKSTableViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if ([self.SKSTableViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.SKSTableViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if ([self.SKSTableViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
    {
        [self.SKSTableViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style])
    {
        self.shouldExpandOnlyOneCell = NO;
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

//已展开cell indexpath
//index is path.section, elemens are array of indexpath
//注意是被展开cell
- (NSMutableArray *)expandedIndexPaths
{
    if (!_expandedIndexPaths)
        _expandedIndexPaths = [NSMutableArray array];
    
    return _expandedIndexPaths;
}

//key: indexpath, value: bool, yes or not.指明是否可展开
//同时记录该path是否可展开，注意该path是转换后的path
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
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath]) {
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
            return [_SKSTableViewDelegate tableView:tableView heightForRowAtIndexPath:[self correspondingIndexPathForRowAtIndexPath:indexPath]];
        }
    } else {
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForSubRowAtIndexPath:)]) {
            return [_SKSTableViewDelegate tableView:tableView heightForSubRowAtIndexPath:[self correspondingIndexPathForSubRowAtIndexPath:indexPath]];
        }
    }
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //判断是否是二级cell
    //第一级
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath]) {
        
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
        SKSTableViewCell *cell = (SKSTableViewCell *)[_SKSTableViewDelegate tableView:tableView cellForRowAtIndexPath:tempIndexPath];
        
        if ([cell isKindOfClass:[SKSTableViewCell class]])
        {
            if ([[self.expandableCells allKeys] containsObject:tempIndexPath])
            {
                [cell setIsExpanded:[[self.expandableCells objectForKey:tempIndexPath] boolValue]];
            }
            else
            {
                [cell setIsExpanded:NO];
            }
        }

        return cell;
        
    } else {    //如果是二级cell
        
        NSIndexPath *indexPathForSubrow = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        UITableViewCell *cell = [_SKSTableViewDelegate tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:indexPathForSubrow];
        
        return cell;
        
    }
}


#pragma mark - Optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = 1;
    if ([_SKSTableViewDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        
        numberOfSections = [_SKSTableViewDelegate numberOfSectionsInTableView:tableView];
    }
    if ([self.expandedIndexPaths count] != numberOfSections)
        [self.expandedIndexPaths initiateObjectsForCapacity:numberOfSections];
    
    return numberOfSections;
}

/*
 *  Uncomment the implementations of the required methods.
 */

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
//        return [_SKSTableViewDelegate tableView:tableView titleForHeaderInSection:section];
//    
//    return nil;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:titleForFooterInSection:)])
//        return [_SKSTableViewDelegate tableView:tableView titleForFooterInSection:section];
//    
//    return nil;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
//    
//    return NO;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView canMoveRowAtIndexPath:indexPath];
//    
//    return NO;
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
//        [_SKSTableViewDelegate sectionIndexTitlesForTableView:tableView];
//    
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)])
//        [_SKSTableViewDelegate tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
//    
//    return 0;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
//}

#pragma mark - UITableViewDelegate

#pragma mark - Optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是一级cell
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath])
    {
        //计算转换path
        NSIndexPath *convertedPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
        //该项是否已展开
        BOOL pathIsExpanded = [[self.expandableCells objectForKey:convertedPath] boolValue];
        //展开则直接关则
        if (pathIsExpanded)
        {
            [self setRow:convertedPath expand:NO];
            self.expath = nil;
        }
        else    //未展开则判断是否允许多项展开
        {
            if (self.shouldExpandOnlyOneCell &&
                _expath != nil)
            {
                [self setRow:_expath expand:NO];
            }
            [self setRow:convertedPath expand:YES];
            if (self.shouldExpandOnlyOneCell)
            {
                _expath = convertedPath;
            }
            //传递展开事件到代理
            if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didExpandRowAtIndexPath:originalIndexPath:)])
            {
                [_SKSTableViewDelegate tableView:(SKSTableView *)tableView
                         didExpandRowAtIndexPath:convertedPath
                               originalIndexPath:indexPath];
            }
        }
        //将点击事件也传递到代理
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        {
            [_SKSTableViewDelegate tableView:tableView
                     didSelectRowAtIndexPath:convertedPath];
        }
    }
    else
    {
    //二级cell
    //直接将点击事件传递到代理
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSIndexPath *indexPathForSubrow = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
            [_SKSTableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPathForSubrow];
    }
}

- (void)setRow:(NSIndexPath *)indexPath expand:(BOOL)expand
{
    __block SKSTableViewCell *cell = (SKSTableViewCell *)[self cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[SKSTableViewCell class]] &&
        cell.isExpanded != expand &&
        cell.isExpandable)
    {
        cell.isExpanded = expand;
    }
    
    NSInteger numberOfSubRows = [self numberOfSubRowsAtIndexPath:indexPath];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    for (NSInteger index = 1; index <= numberOfSubRows; index++) {
        
        NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row+index inSection:section];
        [indexPaths addObject:expIndexPath];
    }
    
    if (expand) {
        
        [self setIsExpanded:YES forCellAtIndexPath:indexPath];
        if (indexPaths.count > 0)
        {
            [self insertExpandedIndexPaths:indexPaths forSection:indexPath.section];
            [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        }
        
    } else {
        [self setIsExpanded:NO forCellAtIndexPath:indexPath];
        if (indexPaths.count > 0)
        {
            [self removeExpandedIndexPaths:indexPaths forSection:indexPath.section];
            for (NSIndexPath* path in indexPaths) {
                UITableViewCell *cell = [self cellForRowAtIndexPath:path];
                cell.hidden = YES;
            }
            [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (BOOL)indexPathIsExpandable:(NSIndexPath *)indexPath
{
    return [self.SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:indexPath] > 0;
}

/*
 *  Uncomment the implementations of the required methods.
 */

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
        [_SKSTableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}
//
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView willDisplayFooterView:view forSection:section];
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
//    
//    return [tableView rowHeight];
//}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
        return [_SKSTableViewDelegate tableView:tableView heightForHeaderInSection:section];
    
    return 0;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
//        [_SKSTableViewDelegate tableView:tableView heightForFooterInSection:section];
//    
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
//    
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)])
//        [_SKSTableViewDelegate tableView:tableView estimatedHeightForHeaderInSection:section];
//
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)])
//        [_SKSTableViewDelegate tableView:tableView estimatedHeightForFooterInSection:section];
//    
//    return 0;
//}
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
        [_SKSTableViewDelegate tableView:tableView viewForHeaderInSection:section];
    
    return nil;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
//        [_SKSTableViewDelegate tableView:tableView viewForFooterInSection:section];
//    
//    return nil;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
//    
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
//    
//    return nil;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
//    
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
//    
//    return UITableViewCellEditingStyleNone;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
//    
//    return nil;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
//    
//    return NO;
//}
//
//- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
//    
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
//    
//    return 0;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
//    
//    return NO;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
//        [_SKSTableViewDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
//    
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
//        [_SKSTableViewDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
//}

#pragma mark - SKSTableViewUtils

- (IBAction)expandableButtonTouched:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath)
        [self tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:[self correspondingIndexPathForRowAtIndexPath:indexPath]];
}

//由原始path得到转换后的path
//由index = 0 -> path.row 进行迭代
/**
 *  while index < path.row
 *      tempPath = 获得section=path.section,row=index的path得到的path
 *      如果tempPath是已展开的cell,
 *          index += 展开数
 *      或者
 *          index ++
 *      无论如何，row ++
 *
 *  return path = path.section, row.
 *
 */
- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = 0;
    NSUInteger row = 0;
    
    while (index < indexPath.row)
    {
        NSIndexPath *getIndexPath = [NSIndexPath indexPathForRow:row
                                                       inSection:indexPath.section];
        //NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:getIndexPath];
        NSIndexPath *tempIndexPath = getIndexPath;
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tempIndexPath] ? [[self.expandableCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded)
        {
            NSInteger numberOfExpandedRows = [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
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
    
    while (index < indexPath.row) {
        
        NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tempIndexPath] ? [[self.expandableCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded) {
            
            NSInteger numberOfExpandedRows = [_SKSTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
            if ((indexPath.row - index) <= numberOfExpandedRows) {
                subrow = indexPath.row - index;
                DebugNSLog(@"indexPath.row = %ld", indexPath.row);
                DebugNSLog(@"index = %ld", index);
                break;
            }
            
            index += (numberOfExpandedRows + 1);
            
        } else
            index++;
        
        row++;
    }
    
    return [NSIndexPath indexPathForSubRow:subrow inRow:row inSection:indexPath.section];
}


//TODO: 暂时未用到，注释掉了subrow的偏移
- (NSIndexPath *)originPathForConvertedPath:(NSIndexPath *)oPath
{
    NSInteger idx = 0;
    NSInteger row = 0;
    while (row < oPath.row) {
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
    
//    idx += oPath.subRow - 1;
    return [NSIndexPath indexPathForRow:idx inSection:oPath.section];
}

- (void)setIsExpanded:(BOOL)isExpanded forCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    [self.expandableCells setObject:[NSNumber numberWithBool:isExpanded] forKey:correspondingIndexPath];
}

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
    [self.expandedIndexPaths[section] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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

//static const void *subrowKey;

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

