//
//  HYHotelMainKeywordCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelMainKeywordCell.h"
#import "Masonry.h"

@implementation HYHotelMainKeywordCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
//        self.detailTextLabel.textColor = [UIColor blackColor];
//        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        
        UITextField *keyField = [[UITextField alloc] initWithFrame:CGRectZero];
        keyField.font = [UIFont systemFontOfSize:16.0];
        keyField.textColor = [UIColor blackColor];
        keyField.textAlignment = NSTextAlignmentLeft;
        keyField.placeholder = @"关键字/位置/品牌/酒店名";
        keyField.returnKeyType = UIReturnKeyDone;
        keyField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:keyField];
        self.keyField = keyField;
        [keyField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-5);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //self.detailTextLabel.frame = CGRectMake(140, 12, 140, 20);
}


@end
