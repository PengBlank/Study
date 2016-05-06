//
//  HYAgencyCardListViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"
#import "HYAgencyInfo.h"
/**
 *  票务中心会员卡信息
 */
@interface HYAgencyCardListViewController : HYBaseDetailViewController

/**
 *  票务中心信息对象
 */
@property (nonatomic, strong) HYAgencyInfo *agencyInfo;

@end
