//
//  HYMallCartSecFooter.h
//  Teshehui
//
//  Created by Kris on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYMallCartSecFooter : UIView

typedef void(^BtnBlock)(void);

@property (nonatomic, copy) BtnBlock firstBlock;
@property (nonatomic, copy) BtnBlock secBlock;

@end
