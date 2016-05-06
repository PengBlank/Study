//
//  SubCategoryCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "SubCategoryCell.h"
#import "UIColor+hexColor.h"
#import "Masonry.h"
#import "DefineConfig.h"
@implementation SubCategoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        //        CGRect bounds = self.contentView.bounds;
        self.merchantCountLabel = [[UILabel alloc]init];
         self.merchantCountLabel.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview: self.merchantCountLabel];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview: self.titleLabel];
        
        WS(weakSelf);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
        }];
        
        [self.merchantCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-15);
        }];
       // self.merchantCountLabel = merchantCountLabel;
        
        
        //
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenRect.size.width, 40)];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexColor:@"f3f3f3" alpha:1];

    }else{
        self.contentView.backgroundColor = [UIColor colorWithHexColor:@"ffffff" alpha:1];
    }
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    if (selected)
    {
        self.titleLabel.textColor =  [UIColor colorWithHexColor:@"b80000" alpha:1];
       
    }else
    {
        self.titleLabel.textColor = [UIColor colorWithHexColor:@"666666" alpha:1.0];
    }

}

@end
