//
//  HYTaxiOrderListCell.h
//  Teshehui
//
//  Created by HYZB on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTaxiOrder.h"
#import "HYTaxiOrderListExpandedModel.h"

@protocol HYTaxiOrderListCellDelegate <NSObject>

- (void)payTaxiMoneyWithBtn:(UIButton *)btn;

@end

@interface HYTaxiOrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic, strong) UIButton *goToPayMoneyBtn;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *taxiTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLab;
@property (weak, nonatomic) IBOutlet UILabel *startAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *endAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *taxiMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *taxiMoneyTitleLab;

@property (nonatomic, weak) id <HYTaxiOrderListCellDelegate>delegate;

/**
 *  填充数据
 */
- (void)setCellInfoWithModel:(HYTaxiOrder *)model;
/**
 *  订单完成和关闭样式
 */
- (void)setCellCompleteType;
/**
 *  订单进行中和未完成样式
 */
- (void)setCellOtherStatusTypeWithPartsIsHiden:(BOOL)isHiden;

@end
