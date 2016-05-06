//
//  HYCIPaymentInfoCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/7/16.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

@interface HYCIPaymentInfoCell : HYBaseLineCell

@property (nonatomic, weak) IBOutlet UILabel *orderNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *productLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderAmountLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderPointLabel;

@end
