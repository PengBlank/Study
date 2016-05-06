//
//  HYMovieTicketOrderListCell.h
//  Teshehui
//
//  Created by HYZB on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseLineCell.h"

@class HYMovieTicketOrderListFrame;

@interface HYMovieTicketOrderListCell :HYBaseLineCell

@property (nonatomic, strong) HYMovieTicketOrderListFrame *cellFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
