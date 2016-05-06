//
//  LoadNullView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/20.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "LoadNullView.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
@interface LoadNullView ()
@property (nonatomic, strong) UIImageView   *backgroundImage;
@end

@implementation LoadNullView
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text secondText:(NSString *)secondText offsetY:(CGFloat)offsetY
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor  = [UIColor clearColor];
        
        _backgroundImage = [[UIImageView alloc] init];
        [_backgroundImage setImage:[UIImage imageNamed:imageName]];
        [self addSubview:_backgroundImage];
        
        _desLabel = [[UILabel alloc] init];
        [_desLabel setText:text];
        _desLabel.font = [UIFont systemFontOfSize:g_fitFloat(@[@14,@15,@15])];
        _desLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
        [_desLabel setNumberOfLines:0];
        [_desLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_desLabel];
        
        [_backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(offsetY);
        }];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backgroundImage.mas_bottom).offset(10);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
        
        if (secondText.length != 0) {
            
            _secondLabel = [[UILabel alloc] init];
            [_secondLabel setText:secondText];
            _secondLabel.font = [UIFont systemFontOfSize:g_fitFloat(@[@13,@14,@14])];
            _secondLabel.textColor = [UIColor colorWithHexString:@"0x606060"];
            [_secondLabel setNumberOfLines:0];
            [_secondLabel setTextAlignment:NSTextAlignmentCenter];
            [self addSubview:_secondLabel];
            
            [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_desLabel.mas_bottom).offset(7);
                make.left.equalTo(self);
                make.right.equalTo(self);
            }];
        }
    }
    return self;
}

- (void)updateText:(NSString *)text secondText:(NSString *)secondText{
    _desLabel.text = text;
    if (secondText.length != 0) {
         _secondLabel.text = secondText;
    }
}

@end
