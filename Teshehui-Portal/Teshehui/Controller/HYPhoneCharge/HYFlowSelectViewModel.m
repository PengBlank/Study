 //
//  HYFlowSelectViewModel.m
//  Teshehui
//
//  Created by Kris on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYFlowSelectViewModel.h"
#import "HYFlowSelectCell.h"

@interface HYFlowSelectViewModel ()
<UITableViewDataSource>

@end

@implementation HYFlowSelectViewModel

#pragma mark tableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYFlowSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              NSStringFromClass([HYFlowSelectCell class])];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

@end
