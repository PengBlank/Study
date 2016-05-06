//
//  MapItemCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "MapItemCell.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIView+Frame.h"
@implementation MapItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0f;
        self.clipsToBounds = YES;
        
//        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.rightBtn setBackgroundColor:[UIColor orangeColor]];
//        [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.rightBtn];
//    
//        self.icon = [[UIImageView alloc] init];
//        [self.icon setImage:IMAGE(@"didi")];
//        [self.rightBtn addSubview:self.icon];
//    
//        self.iconTitle = [[UILabel alloc] init];
//        [self.iconTitle setText:@"滴滴"];
//        [self.iconTitle setTextColor:[UIColor whiteColor]];
//        [self.iconTitle setFont:[UIFont systemFontOfSize:13]];
//        [self.rightBtn addSubview:self.iconTitle];
        
        self.title = [[UILabel alloc] init];
        [self.title setText:@"小肥羊（南山店）"];
        [self.title setTextColor:[UIColor colorWithString:@"434343"]];
        [self.title setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:self.title];
        
        self.addressIcon = [[UIImageView alloc] init];
        [self.addressIcon setImage:IMAGE(@"address")];
        [self addSubview:self.addressIcon];
        
        self.subTitle = [[UILabel alloc] init];
        [self.subTitle setText:@"深圳市南山区南油生活A区"];
        [self.subTitle setTextColor:[UIColor colorWithString:@"272727"]];
        [self.subTitle setFont:[UIFont systemFontOfSize:13]];
        self.subTitle.numberOfLines = 3;
        [self addSubview:self.subTitle];
        
      //  CGFloat height = frame.size.height;
        
//        [self.rightBtn setFrame:CGRectMake(0, 0, 70, height)];
//        [self.icon setFrame:CGRectMake(self.rightBtn.centerX - 13, frame.origin.y + 10, 26, 22)];
//        [self.iconTitle setFrame:CGRectMake(self.icon.x, self.icon.y + 22 + 5, 26, 20)];
        
    //    WS(weakSelf);
//        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakSelf.mas_left);
//            make.top.mas_equalTo(weakSelf.mas_top);
//            make.width.mas_equalTo(70);
//            make.height.mas_equalTo(height);
//        }];
        
//        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(weakSelf.rightBtn.mas_centerX);
//            make.top.mas_equalTo(weakSelf.rightBtn.mas_top).offset(10);
//            make.size.mas_equalTo(CGSizeMake(26, 22));
//        }];
//        
//
//        [self.iconTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(weakSelf.rightBtn.mas_centerX);
//            make.top.mas_equalTo(weakSelf.icon.mas_bottom).offset(5);
//        }];
//        
//        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(weakSelf.mas_top).offset(10);
//            make.left.mas_equalTo(weakSelf.mas_left).offset(10);
//           // make.right.mas_equalTo(weakSelf.mas_right).offset(-5);
//        }];
        
        //
        //        [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.bottom.mas_equalTo(weakSelf.mas_bottom);
        //            make.right.mas_equalTo(weakSelf.mas_right).offset(-5);
        //
        //        }];
        
        //        [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.mas_equalTo(weakSelf.subTitle.mas_centerY);
        //            make.left.mas_equalTo(weakSelf.mas_left).offset(10);
        //            make.size.mas_equalTo(CGSizeMake(13, 20));
        //             make.right.lessThanOrEqualTo(weakSelf.subTitle.mas_left).with.offset(-2);
        //        }];
        
        [self.title setFrame:CGRectMake(10, frame.origin.y + 8, frame.size.width - 85, 20)];
//        

        [self.addressIcon setFrame:CGRectMake(self.title.x, self.title.y + self.title.height + g_fitFloat(@[@12,@5,@5]), 13, 20)];

        
         [self.subTitle setFrame:CGRectMake(self.addressIcon.x + self.addressIcon.width + 3, self.addressIcon.y, frame.size.width - 30, g_fitFloat(@[@75,@40,@40]))];
        [self.subTitle setCenterY:self.addressIcon.centerY];
        
        
    }
    return self;
}

- (void)rightBtnClick{
    DebugNSLog(@"滴滴滴滴滴的");
}

@end
