//
//  HYActivityTableViewCell.h
//  Teshehui
//
//  Created by HYZB on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYProductListSummary.h"

@interface HYActivityTableViewCell : UITableViewCell
{
    UIImageView *_textBgView;
    HYProductListSummary *_category;
}
@property (nonatomic, assign) BOOL evenIndex;

- (void)setWithCategory:(HYProductListSummary *)category;

@end
