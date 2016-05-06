//
//  HYSplitViewController+UmengShake.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-6.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSplitViewController.h"
#import "UMSocial.h"
#import "UMSocialShakeService.h"

@interface HYSplitViewController (UmengShake)
<UMSocialShakeDelegate,
UMSocialUIDelegate>

- (void)umengShake;
- (void)stopShake;

@end
