//
//  HYTaxiAlertView.h
//  Teshehui
//
//  Created by Kris on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonBlock)(void);

@interface HYTaxiAlertView : UIView

@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIImageView *mainImgView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (nonatomic, copy) ButtonBlock firstBlock;
@property (nonatomic, copy) ButtonBlock secondBlock;

+ (instancetype)instanceView;
- (void)show;
- (void)dismiss;

@end
