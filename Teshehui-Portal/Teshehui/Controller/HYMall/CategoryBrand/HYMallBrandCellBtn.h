//
//  HYMallBrandCellBtn.h
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYXibView.h"
#import "HYMallBrandSecModel.h"
#import "HYMallGuessYouLikeModel.h"

@interface HYMallBrandCellBtn : HYXibView

@property (strong, nonatomic, readonly) UIButton *clickBtn;
@property (strong, nonatomic, readonly) id data;

-(void)setData:(id)data;

@end
