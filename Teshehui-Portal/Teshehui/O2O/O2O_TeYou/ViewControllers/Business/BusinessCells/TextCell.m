//
//  TextCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TextCell.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
@implementation TextCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"0x272727"]];
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];

        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"0x434343"]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_contentLabel];
        
        WS(weakSelf);
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
            make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(10);
        }];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.titleLabel.mas_left);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-15);
            make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
        }];
    }
    return self;
}

- (void)bindata:(BusinessdetailInfo *)baseInfo{

    if (baseInfo == nil) {
        return;
    }

    [_titleLabel setText:@"简介"];
    [_contentLabel setText:baseInfo.MDescription];
    tmpString = _contentLabel.text == nil ? @"呵呵" : baseInfo.MDescription;
}

- (CGFloat)cellHeight{
    
    CGSize size = [tmpString sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 30 , 100000)];
    return size.height + (_contentLabel.text.length == 0 ? 30 : 44);
}

@end
