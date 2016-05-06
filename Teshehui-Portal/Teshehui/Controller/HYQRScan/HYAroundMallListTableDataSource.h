//
//  HYAroundMallListTableDataSource.h
//  Teshehui
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYAroundMallListTableDataSource : NSObject
<UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *items;

- (id)itemAtIndexPath:(NSIndexPath *)idxPath;

- (void)cleanData;

@end
