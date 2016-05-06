//
//  TicketDateViewController.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketDateViewController : UIViewController

@property (copy, nonatomic) void(^TicketDateSelected)(NSString *date);
@property (weak, nonatomic) NSString *serverDate;
@property (weak, nonatomic) NSString *selectedDate;

@end
