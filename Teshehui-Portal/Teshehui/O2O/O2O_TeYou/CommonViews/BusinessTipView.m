//
//  BusinessTipView.m
//  Teshehui
//
//  Created by apple_administrator on 15/11/19.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BusinessTipView.h"
#import "UIColor+expanded.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIView+Frame.h"
@interface BusinessTipView ()
@property (nonatomic ,strong) UILabel   *titleLabel;
@property (nonatomic ,strong) UIButton  *cancelBtn;

@end

@implementation BusinessTipView

- (id)initWithFrame:(CGRect)frame businessNum:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setBackgroundColor:UIColorFromRGB(255, 144, 0)];
        self.alpha = 0;
        self.layer.cornerRadius = 4.0f;
        
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setText:[NSString stringWithFormat:@"发现%@家使用现金券的消费场所",@(count)]];
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [self addSubview:self.titleLabel];
        
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"closered"] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        
        CGSize tmpSize = [_titleLabel.text sizeWithFont:[UIFont systemFontOfSize:15]
                                     constrainedToSize:CGSizeMake(frame.size.width , frame.size.height)];

        [self setWidth:tmpSize.width + g_fitFloat(@[@8,@10,@15])*2 + 30];
        [self setX:kScreen_Width/2 - self.width/2];
        
        WS(weakSelf);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
            make.left.mas_equalTo(weakSelf.mas_left).offset(15);
        }];

        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.titleLabel.mas_centerY);
            make.right.mas_equalTo(weakSelf.mas_right).offset(-g_fitFloat(@[@8,@10,@15]));
//            make.left.mas_equalTo(weakSelf.titleLabel.mas_right).offset(g_fitFloat(@[@8,@10,@15]));
//            make.width.mas_equalTo(@22);
        }];

    }
    return self;
}

- (void)show{
    
    _isHidden = NO;
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^{
        b_self.alpha = 0.8;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)dismiss{
    
     _isHidden = YES;
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
          b_self.alpha = 0;
         
     } completion:^(BOOL finished)
     {
       //  [b_self removeFromSuperview];
     }];
}

@end
