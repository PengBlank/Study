//
//  HYUserQrcodeView.h
//  Teshehui
//
//  Created by Kris on 15/7/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYUserQrcodeView : UIView

+ (instancetype)instanceView;
//- (void)show;

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, strong) UIImage *qrcodeImage;

@end
