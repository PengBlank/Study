//
//  HYFlowerMainTableViewCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-5-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYFlowerTypeInfo.h"

@interface HYFlowerMainTableViewCell : UITableViewCell
{
    UIImageView *_textBgView;
}

@property (nonatomic, assign) BOOL evenIndex;
@property (nonatomic, strong) HYFlowerTypeInfo *item;

@end
