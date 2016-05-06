//
//  HYMallParamView.h
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYProductSKU.h"

@protocol HYMallParamViewDelegate <NSObject>

- (void)didSelectProductParam:(HYProductSKU *)param
                        index:(NSInteger)index
                 isAttribute1:(BOOL)isAttribute1;

@end

@interface HYMallParamView : UIView
{
    CGFloat _height;
}

@property (nonatomic, weak) id<HYMallParamViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currSelectIndex;
@property (nonatomic, assign) NSInteger showAttribute1;
@property (nonatomic, strong) NSArray *paramInfo;
@property (nonatomic, assign, readonly) CGFloat height;

@end
