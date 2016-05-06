//
//  LocationErrorView.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

typedef void (^cityBtnClick)(UIButton *btn);

#import <UIKit/UIKit.h>

@interface LocationErrorView : UIView

@property (nonatomic,copy)cityBtnClick  selectCityBlock;

@end
