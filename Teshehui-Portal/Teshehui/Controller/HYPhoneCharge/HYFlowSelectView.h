//
//  HYFlowSelectView.h
//  Teshehui
//
//  Created by Kris on 16/2/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYXibView.h"

@protocol HYFlowSelectViewDelegate <NSObject>
@end

@interface HYFlowSelectView : HYXibView

@property (nonatomic, weak) id<HYFlowSelectViewDelegate> delegate;

@end
