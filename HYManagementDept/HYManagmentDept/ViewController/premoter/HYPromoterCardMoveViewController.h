//
//  HYPromoterCardMoveViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"
#import "HYPublicView.h"

/**
 *  业务员会员卡转移
 */
@interface HYPromoterCardMoveViewController : HYBaseDetailViewController
<HYPublicViewDelegate>

@property (nonatomic, readonly) HYPublicView *publicView;

- (void)loadPromoterList;

@end
