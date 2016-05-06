//
//  HYMallCateSubCell.h
//  Teshehui
//
//  Created by 成才 向 on 16/3/21.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMallCategoryInfo.h"

@interface HYMallCateSubCell : UITableViewCell

@property (nonatomic, strong) HYMallCategoryInfo *cateInfo;
@property (nonatomic, copy) void (^didClickSubcate)(HYMallCategoryInfo *cate);

@end
