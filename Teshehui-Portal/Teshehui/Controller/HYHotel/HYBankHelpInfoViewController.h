//
//  HYBankHelpInfoViewController.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelViewBaseController.h"

typedef enum _BankHelpType{
    CardValidDate = 1,
    CardNumberLast
}BankHelpType;

@interface HYBankHelpInfoViewController : HYHotelViewBaseController

@property (nonatomic, assign) BankHelpType type;

@end
