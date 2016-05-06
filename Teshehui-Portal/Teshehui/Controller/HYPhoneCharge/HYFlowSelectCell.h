//
//  HYFlowSelectCell.h
//  Teshehui
//
//  Created by Kris on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYPhoneChargeModel.h"

@interface HYFlowSelectCell : HYBaseLineCell

//- (void)setData;

@property (nonatomic, strong) HYPhoneChargeModel *chargeModel;

@property (nonatomic, copy) void (^chargeCallback)(HYPhoneChargeModel *model);

@end
