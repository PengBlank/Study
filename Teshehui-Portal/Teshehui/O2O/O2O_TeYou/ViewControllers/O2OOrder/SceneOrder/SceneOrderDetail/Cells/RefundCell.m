//
//  RefundCell.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "RefundCell.h"
#import "Masonry.h"
#import "UILabel+Common.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
@implementation RefundCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _reasonLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor colorWithHexString:@"0x343434"]];
        _desLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor colorWithHexString:@"0x343434"]];
        [self.contentView addSubview:_reasonLabel];
        [self.contentView addSubview:_desLabel];
        
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"choosePriceType"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"return_choose"] forState:UIControlStateSelected];
        _selectBtn.userInteractionEnabled = NO;
        [self.contentView addSubview:_selectBtn];
        
        // 线
        
    
        
        WS(weakSelf);
        [_reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(12.5);
            make.right.equalTo(weakSelf).offset(-12.5);
            make.centerY.equalTo(weakSelf);
        }];
        
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-12.5);
            make.centerY.equalTo(weakSelf);
        }];
        
        [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-12.5);
            make.centerY.equalTo(weakSelf);
        }];
    }
    return self;
}

- (void)bindData:(NSArray *)dataArray reasonArray:(NSMutableArray *)reasonArray indexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.section == 0) {
        _selectBtn.hidden = YES;
        _desLabel.hidden = NO;
        switch (indexPath.row) {
            case 0:
            {
//                [_reasonLabel setText:@"一场风花雪月的邂逅意大利式风情"];
                [_reasonLabel setText:dataArray[0]];
                
            }
                break;
            case 1:
            {
                [_reasonLabel setText:@"数量"];
//                [_desLabel setText:@"1份"];
                [_desLabel setText:dataArray[1]];
            }
                break;
            case 2:
            {
                [_reasonLabel setText:@"退还金额"];
//                [_desLabel setText:@"¥120 + 200现金券"];
                [_desLabel setText:dataArray[2]];
                [_desLabel setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
            }
                break;
                
            default:
                break;
        }
    }else{
         _selectBtn.hidden = NO;
        _desLabel.hidden = YES;
        [_reasonLabel setText:reasonArray[indexPath.row]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    if (selected)
    {
        _selectBtn.selected = YES;
    }else
    {
         _selectBtn.selected = NO;
    }
}


@end
