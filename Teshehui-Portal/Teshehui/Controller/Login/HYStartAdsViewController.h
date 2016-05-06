//
//  HYStartAdsViewController.h
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYStartAdsViewController : UIViewController

@property (nonatomic, copy) void (^startAdsCallback)(BOOL skiped);

@end
