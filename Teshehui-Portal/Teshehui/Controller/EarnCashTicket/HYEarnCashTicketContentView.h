//
//  HYEarnCashTicketContentView.h
//  Teshehui
//
//  Created by HYZB on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYGetTranscationTypeResponse.h"
#import "HYEarnTicketHeaderView.h"

@protocol HYEarnCashTicketContentViewDelegate <NSObject>


- (void)didSelectUpgrad;
/** 界面跳转 */
- (void)didSelectWithEarnType:(HYBusinessType*)type;

@end

@interface HYEarnCashTicketContentView : UIView

@property (nonatomic, strong) HYEarnTicketHeaderView *head;
@property (nonatomic, weak) id<HYEarnCashTicketContentViewDelegate> delegate;

@end
