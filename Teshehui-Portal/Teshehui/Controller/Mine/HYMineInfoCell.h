//
//  HYMineInfoCell.h
//  Teshehui
//
//  Created by HYZB on 15/2/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYMineInfoCell : HYBaseLineCell
{
    UIImageView *_redPointView;
    UIImageView *_indicator;
}

@property (nonatomic, assign) BOOL hasNew;
@property (nonatomic, assign) BOOL intent;
@property (nonatomic, assign) BOOL expand;
@property (nonatomic, assign) NSInteger redCount;

@end
