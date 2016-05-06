//
//  TicketScreenshot.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TicketScreenshotCallback)(BOOL saveSuccess , NSError *error);

@interface TicketScreenshot : UITableView

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgQR;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblPayDate;

@property (copy, nonatomic) TicketScreenshotCallback screenshotResult;

+ (TicketScreenshot *)sharedConstant;
- (void) setDataSource:(id<UITableViewDataSource>)dataSource
              Delegate:(id<UITableViewDelegate>)delegate
           TicketTitle:(NSString *)title
               Payment:(NSString *)price
               PayDate:(NSString *)date
                qrCode:(NSString *)qr
              callback:(TicketScreenshotCallback) screenshotResult;

@end
