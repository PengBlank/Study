//
//  HYEarnTicketCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYGetTranscationTypeResponse.h"


@protocol HYEarnTicketDelegate <NSObject>

- (void)didSelectWithEarnType:(HYBusinessType *)type;

@end

@interface HYEarnTicketCell : UITableViewCell

@property (nonatomic, assign) BOOL isFull;  //default no.
@property (nonatomic, strong) HYBusinessType *leftBusinessType;
@property (nonatomic, strong) HYBusinessType *rightBusinessType;

@property (nonatomic, weak) id<HYEarnTicketDelegate> delegate;

@end
