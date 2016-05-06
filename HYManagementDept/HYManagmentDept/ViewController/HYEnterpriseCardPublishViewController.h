//
//  HYEnterpriseCardPublishViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-7-10.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"
#import "HYPublicView.h"
/**
 *  企业会员卡批发
 * 指定企业
 */
@interface HYEnterpriseCardPublishViewController : HYBaseDetailViewController
<HYPublicViewDelegate>
- (void)loadAgencyList;

@property (nonatomic, readonly) HYPublicView *publicView;

@end
