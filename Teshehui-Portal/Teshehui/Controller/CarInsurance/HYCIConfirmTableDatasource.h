//
//  HYCIConfirmTableDatasource.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  实际的tableview datasource依然还是viewcontroller，
 *  这个对像只是一个容器，存放界面操作所产生的各种变量
 *  这样做可以减少view controller中的大量逻辑判断
 */

typedef enum
{
    HYCiConfirmSectionOrder = 0,
    HYCiConfirmSectionDeliver,
    HYCiConfirmSectionShengmin,
    HYCiConfirmSectionApplicant,
    HYCiConfirmSectionRecognizor
}HYCIConfirmSection;

@interface HYCIConfirmTableDatasource : NSObject
{
    NSMutableArray *_numOfRows;
    NSMutableArray *_sectionIsExpanded;
    
    NSInteger _orderOffset, _deliverOffset;
}

//供view controller使用
@property (nonatomic, assign) NSInteger numOfSection;
- (NSInteger)numOfRowsInSection:(NSInteger)section;

//将所有indexPath统统转换为展开情况下的indexPath,减少逻辑判断
- (NSIndexPath *)transferedPathWithIndexPath:(NSIndexPath *)path;

//设置数据源是否为展开，section代表: 0:订单信息 1:配送信息 2投保声明(不可用)
- (void)setSection:(HYCIConfirmSection)section isExpanded:(BOOL)expand;
- (BOOL)sectionIsExpanded:(HYCIConfirmSection)section;

- (void)setInsureInfoRowCount:(NSInteger)count;

@end
