//
//  SearchHistoryCell.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SearchHistoryCell.h"
#import "UILabel+Common.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
@implementation SearchHistoryCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _mainImageV = [[UIImageView alloc] init];
        [_mainImageV setImage:[UIImage imageNamed:@"btn_searchgrye"]];
        [self.contentView addSubview:_mainImageV];
        
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"0x343434"]];
        [_titleLabel setText:@"诉说三五旧事 共度美好时光我有故事你有酒吗？我有故事你有酒吗？"];
        [self.contentView addSubview:_titleLabel];

        
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_clearBtn];
        
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints{
    
    WS(weakSelf);
    [_mainImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(12.5);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mainImageV);
        make.left.equalTo(weakSelf.mainImageV.mas_right).offset(7.5);
    }];
    
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-15);
        
    }];
}

- (void)bindData:(NSString *)keyword{
    self.currentkey = keyword;
    [self.titleLabel setText:keyword];
}

- (void)buttonPressed:(UIButton *)btn{
    
    if (_clearBtnClick) {
        _clearBtnClick(self.currentkey);
    }
}

@end
