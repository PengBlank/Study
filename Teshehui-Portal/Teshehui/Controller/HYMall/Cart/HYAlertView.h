//
//  HYAlertView.h
//  Teshehui
//
//  Created by Kris on 15/12/25.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(void);

@interface HYAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (nonatomic, copy) ButtonBlock firstBlock;
@property (nonatomic, copy) ButtonBlock secondBlock;

+ (instancetype)instanceView;
- (void)show;
- (void)dismiss;

@end
