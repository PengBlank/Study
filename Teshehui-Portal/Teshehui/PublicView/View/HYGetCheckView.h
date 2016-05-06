//
//  HYGetCheckView.h
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYGetCheckView : UIView

@property(nonatomic,strong) UILabel* nameLab;
@property(nonatomic,strong) UITextField* textField;
@property(nonatomic,strong) UIButton* sendCheck;


- (id)initWithFrame:(CGRect)frame authcode:(BOOL)authcode;

@end
