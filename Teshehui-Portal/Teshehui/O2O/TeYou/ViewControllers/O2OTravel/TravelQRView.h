//
//  TravelQRView.h
//  Teshehui
//
//  Created by apple_administrator on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelOrderInfo.h"
@interface TravelQRView : UIView

@property (nonatomic, strong) TravelOrderInfo *travelOrderInfo;

- (void)show;
- (void)setText;
@end
