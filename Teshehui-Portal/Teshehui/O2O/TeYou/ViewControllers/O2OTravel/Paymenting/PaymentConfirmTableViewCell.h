//
//  PaymentConfirmTableViewCell.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYTicketCountModel.h"
#import "TravelTicketsListModel.h"

@interface PaymentConfirmTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *vieWhitewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketName;
@property (weak, nonatomic) IBOutlet UILabel *lblDays;
@property (weak, nonatomic) IBOutlet UILabel *lblCountAdult;
@property (weak, nonatomic) IBOutlet UILabel *lblCountChild;
@property (weak, nonatomic) IBOutlet UILabel *lblSubtotal;

- (void)configureCell:(TravelSightInfo *)tInfo TicketCount:(TYTicketCountModel *)countModel atIndexPath:(NSIndexPath *)indexPath isOriginal:(BOOL)original;

@end
