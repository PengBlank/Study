//
//  HYIndemnityProgressCell.h
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYIndemnityProgress.h"
#import "HYMallGuijiupeiOrderLogItem.h"

@interface HYIndemnityProgressCell : HYBaseLineCell
{
    UIView *_topLine;
    UIView *_buttomLine;
}

@property (nonatomic, assign) BOOL isFrist;
@property (nonatomic, strong) HYMallGuijiupeiOrderLogItem *progress;

@end
