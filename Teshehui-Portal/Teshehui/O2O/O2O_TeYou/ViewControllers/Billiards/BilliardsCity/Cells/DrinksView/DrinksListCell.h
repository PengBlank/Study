//
//  DrinksListCell.h
//  zuoqiu
//
//  Created by wujianming on 15/11/5.
//  Copyright © 2015年 teshehui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goodsInfo.h"
@class DrinksListCell;

typedef void (^SteperBlock)(DrinksListCell *cell, NSInteger count);

@class PKYStepper;

@interface DrinksListCell : UITableViewCell
{
    
}
/** 商品名称*/
@property (nonatomic, strong) UILabel *CommodityName;

/** 原价*/
@property (nonatomic, strong) UILabel *OriginalPrice;

///** 特奢汇价*/
//@property (nonatomic, strong) UILabel *TSHPrice;

@property (nonatomic, strong) NSIndexPath *indexpath;

/** 计数器*/
@property (nonatomic, strong) PKYStepper *countSteper;

@property (nonatomic, copy) SteperBlock steperBlockCallBack;

@property (nonatomic, copy) void (^steperClick)(NSIndexPath *indexPath,float value);

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)binddata:(NSIndexPath *)indexPath goodsInfo:(goodsInfo *)info;

@end
