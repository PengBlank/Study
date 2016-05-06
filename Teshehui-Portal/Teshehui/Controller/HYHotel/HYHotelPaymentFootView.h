//
//  HYHotelPaymentFootView.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYHotelPaymentFootView : UIView
{
    UILabel *_priceLab;
    UILabel *_pointsLab;
}
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *points;

@property (nonatomic, strong) UIButton *orderBtn;

@end
