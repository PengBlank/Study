//
//  HYStartAdsView.h
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYStartAdsViewModel.h"

@protocol HYStartAdsViewDelegate <NSObject>
@end

@interface HYStartAdsView : UIImageView

@property (nonatomic, weak) id<HYStartAdsViewDelegate> adsViewdelegate;

-(void)bindDataWithViewModel:(HYStartAdsViewModel *)viewModel;

@end
