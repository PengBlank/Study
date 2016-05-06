//
//  HYMallOrderAdressListCell.h
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYAddressInfo.h"

@class HYMallOrderAdressListCell;
@protocol HYMallOrderAddressListCellDelegate <NSObject>

// - (void)addressCellDidClickEdit:(HYMallOrderAdressListCell *)cell;
// - (void)addressCellDidClickDelete:(HYMallOrderAdressListCell *)cell;
- (void)addressCellDidClickDefaultBtn:(HYMallOrderAdressListCell *)cell;
- (void)editIconAction:(HYMallOrderAdressListCell *)cell;
- (void)editBtnAction:(HYMallOrderAdressListCell *)cell;

@end

/**
 *  @brief 地址管理cell
 */
@interface HYMallOrderAdressListCell : HYBaseLineCell
{

}

//@property (nonatomic,weak)UIViewController* partentViewControl;
@property (nonatomic, weak) id<HYMallOrderAddressListCellDelegate> delegate;

@property (nonatomic,strong)UILabel* nameLab;

@property (nonatomic,strong)UILabel* adressLab;

@property (nonatomic,strong)UILabel* adressDefaultLab;

@property (nonatomic,strong)UILabel* numLab;

@property (nonatomic, strong) UIButton *editIcon;

@property (nonatomic, strong) UIButton *editbtn;

//-(void)setList:(HYAddressInfo*)info;

@property (nonatomic, strong) HYAddressInfo *addressInfo;

@end
