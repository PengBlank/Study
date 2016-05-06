//
//  HYLineStylePageControl.h
//  Teshehui
//
//  Created by HYZB on 15/1/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYLineStylePageControl : UIControl
{
    UIView *_silderView;
}

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIColor *silderColor;

@end
