//
//  TicketPaySuccessTableViewCell.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTicketCountModel.h"
#import "TravelTicketsListModel.h"

@interface TicketPaySuccessTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketName;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketCount;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketDays;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutCellBottom;

- (void)configureCell:(TravelSightInfo *)tInfo TicketCount:(TYTicketCountModel *)countModel atIndexPath:(NSIndexPath *)indexPath;

@end
