//
//  HYChargeSelectView.h
//  Teshehui
//
//  Created by Kris on 16/2/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYXibView.h"
#import "HYChargeSelectViewModel.h"

@protocol HYChargeSelectViewDelegate <NSObject>
@end


@interface HYChargeSelectView : HYXibView

@property (nonatomic, weak) id<HYChargeSelectViewDelegate> delegate;

- (void)removeData;

@end
