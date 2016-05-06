//
//  ConfirmPayView.h
//  Teshehui
//
//  Created by apple_administrator on 16/1/15.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPayView : UIView

@property (nonatomic,copy)   void (^ConfirmBlock)(NSString *money,NSString *coupon);
@property (nonatomic,assign) BOOL isChange; // 是否改变字段

- (instancetype)initWithFrame:(CGRect)frame payType:(NSInteger)type;
- (void)setMerName:(NSString *)name withSender:(id)sender;


@end
