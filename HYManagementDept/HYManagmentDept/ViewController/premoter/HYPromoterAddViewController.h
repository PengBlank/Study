//
//  HYPromoterAddViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"

/**
 *  添加操作员
 */

typedef enum {
    HYAddPromoter  = 0,
    HYEditPromoter
}HYPromoterAction;

#import "HYPromoters.h"

@interface HYPromoterAddViewController : HYBaseDetailViewController

@property (nonatomic, assign) HYPromoterAction action;
@property (nonatomic, strong) HYPromoters *promotersInfo;
@property (nonatomic, copy) void (^editCallback)(void);

- (void)clearInfo;

@end
