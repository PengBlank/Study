//
//  HYCIConfirmTableDatasource.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIConfirmTableDatasource.h"

@implementation HYCIConfirmTableDatasource

- (instancetype)init
{
    if (self = [super init])
    {
        self.numOfSection = 3;
        //各section的行数
        _numOfRows = [NSMutableArray arrayWithObjects:
                      @(1), //订单信息标题
                      @(5), //车主信息
                      @(1), //投保人信息 可展开
                      @(1), //被保人信息 可展开
                      @(6), //车辆信息 固定六项
                      @(6), //保单信息 动态变化
                      @(5), //配送信息 加标题固定五项
                      @(1), //投保声明 固定一项
                      nil];
        //各section默认展开状态
        _sectionIsExpanded = [NSMutableArray arrayWithObjects:@NO, @YES, @NO, @NO, @NO, nil];
        _orderOffset = 0;
        _deliverOffset = 0;
    }
    return self;
}

- (void)setInsureInfoRowCount:(NSInteger)count
{
    if (count >= 0)
    {
        [_numOfRows replaceObjectAtIndex:5 withObject:@(count)];
    }
}

- (BOOL)sectionIsExpanded:(HYCIConfirmSection)section
{
    if (section < _sectionIsExpanded.count)
    {
        BOOL isExpanded = [[_sectionIsExpanded objectAtIndex:section] boolValue];
        return isExpanded;
    }
    return NO;
}

//设置section展开或关闭后的状态
- (void)setSection:(HYCIConfirmSection)section isExpanded:(BOOL)expand
{
    if (section < _sectionIsExpanded.count)
    {
        BOOL isExpanded = [[_sectionIsExpanded objectAtIndex:section] boolValue];
        if (isExpanded != expand)
        {
            [_sectionIsExpanded replaceObjectAtIndex:section
                                          withObject:[NSNumber numberWithBool:expand]];
            
            
            NSInteger numOfSection = 3;
            
            //订单是否展开
            BOOL orderIsExpand = [[_sectionIsExpanded objectAtIndex:HYCiConfirmSectionOrder] boolValue];
            if (orderIsExpand)
            {
                numOfSection += 5;
            }
            
            self.numOfSection = numOfSection;
            
            //确定配送信息行数
            BOOL deliverIsExpand = [[_sectionIsExpanded objectAtIndex:HYCiConfirmSectionDeliver] boolValue];
            NSInteger deliverRowCount = deliverIsExpand ? 5 : 1;
            [_numOfRows replaceObjectAtIndex:6 withObject:@(deliverRowCount)];
            
            //投保人信息行数
            BOOL applicantIsExpand = [[_sectionIsExpanded objectAtIndex:HYCiConfirmSectionApplicant]
                                      boolValue];
            NSInteger applicantRowCount = applicantIsExpand ? 5 : 1;
            [_numOfRows replaceObjectAtIndex:2 withObject:@(applicantRowCount)];
            
            //被保人信息行数
            BOOL recognizorIsExpand = [[_sectionIsExpanded objectAtIndex:HYCiConfirmSectionRecognizor]
                                      boolValue];
            NSInteger recoRowCount = recognizorIsExpand ? 5 : 1;
            [_numOfRows replaceObjectAtIndex:3 withObject:@(recoRowCount)];
        }
    }
}


//展开时将期中五项缩回
- (NSInteger)transferedSectionWithSection:(NSInteger)section
{
    if (section > 0)
    {
        BOOL orderIsExpand = [[_sectionIsExpanded objectAtIndex:HYCiConfirmSectionOrder] boolValue];
        if (!orderIsExpand && section < 6)
        {
            section += 5;
        }
    }
    return section;
}

- (NSInteger)numOfRowsInSection:(NSInteger)section
{
    section = [self transferedSectionWithSection:section];
    if (section < _numOfRows.count)
    {
        return [[_numOfRows objectAtIndex:section] integerValue];
    }
    return 0;
}

//将正常的indexPath 换算成完全展开情形下的indexPath来进行计算
//减少需要做的逻辑判断
- (NSIndexPath *)transferedPathWithIndexPath:(NSIndexPath *)path
{
    if (path.section > 0)
    {
        return [NSIndexPath indexPathForRow:path.row
                                  inSection:[self transferedSectionWithSection:path.section]];
    }
    return path;
}


@end
