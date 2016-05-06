//
//  HYCIAdditionInfoViewController.h
//  Teshehui
//
//  Created by 成才 向 on 15/12/1.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

/**
 *  @brief  精确报价, 数据补录
 */
@interface HYCIAdditionInfoViewController : HYMallViewBaseController

/**
 *  @brief  需补录数据
 */
@property (nonatomic, strong) NSArray *additionInfoList;

@property (nonatomic, copy) void (^additionInputCallback)(NSArray *infos);

@end
