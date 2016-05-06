//
//  PersonGuideView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/18.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PersonGuideView.h"
#import "DefineConfig.h"

@interface PersonGuideView ()

@property (nonatomic,strong) UIImageView    *imageV;
@property (nonatomic,strong) UIImageView    *imageV2;

@end

@implementation PersonGuideView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.userInteractionEnabled = YES;
        
//        UIView *blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.75]];
//        blackView.userInteractionEnabled = YES;
//        [KEY_WINDOW addSubview:blackView];
//        
//        KEY_WINDOW.userInteractionEnabled = YES;
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kScreen_Width, 300)];
        [_imageV setImage:[UIImage imageNamed:@"tsh_noviceguide"]];
        _imageV.userInteractionEnabled = YES;
        [self addSubview:_imageV];
        

        
        _imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, kScreen_Width, 300)];
        [_imageV2 setImage:[UIImage imageNamed:@"tsh_noviceguide2"]];
        _imageV2.hidden = YES;
         _imageV2.userInteractionEnabled = YES;
        [self addSubview:_imageV2];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personGuideNextStep:)];
        [_imageV addGestureRecognizer:tap];

        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personGuideNextStep2:)];
        [_imageV2 addGestureRecognizer:tap2];
    }
    return self;
}


- (void)personGuideNextStep:(UITapGestureRecognizer *)tap{
    
        [UIView animateWithDuration:0.2 animations:^{
            _imageV.hidden = YES;
            _imageV2.hidden = NO;
        }];
}

- (void)personGuideNextStep2:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.1 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _imageV = nil;
        _imageV2 = nil;
    }];
}
@end
