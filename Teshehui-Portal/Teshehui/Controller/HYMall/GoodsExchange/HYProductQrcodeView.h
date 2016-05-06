//
//  HYProductQrcodeView.h
//  Teshehui
//
//  Created by 成才 向 on 15/5/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYProductQrcodeView : UIView

+ (instancetype)instanceView;
- (void)show;

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, strong) UIImage *qrcodeImage;

@end
