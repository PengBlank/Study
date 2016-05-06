//
//  HYExpensiveExplainView.h
//  Teshehui
//
//  Created by apple on 15/4/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYExpensiveExplainView : UIView

+ (instancetype)instance;
- (void)showWithImage:(UIImage *)img;

@property (nonatomic, copy) NSString *img_key;
@end
