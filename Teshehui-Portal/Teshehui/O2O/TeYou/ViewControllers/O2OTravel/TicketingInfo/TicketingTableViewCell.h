//
//  TicketingTableViewCell.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PKYStepper.h"
#import "TravelTicketsListModel.h"

typedef void (^TicketCellStepperValueChanged)(float countAdult , float countChild , NSIndexPath *indexPath);

@interface TicketingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblTicketName;
@property (weak, nonatomic) IBOutlet UILabel *lblDays;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceAdult;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceChild;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceAdultOriginal;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceChildOriginal;
@property (weak, nonatomic) IBOutlet PKYStepper *stepperAdult;
@property (weak, nonatomic) IBOutlet PKYStepper *stepperChild;

@property (weak, nonatomic) IBOutlet UIImageView *imgSelected;

@property ( nonatomic , copy ) NSIndexPath *indexPath;
@property ( nonatomic , copy ) TicketCellStepperValueChanged stepperChanged;
- (void)configureCell:(TravelSightInfo *)baseInfo TicketCount:(NSDictionary *)dicCount atIndexPath:(NSIndexPath *)indexPath;

@end
