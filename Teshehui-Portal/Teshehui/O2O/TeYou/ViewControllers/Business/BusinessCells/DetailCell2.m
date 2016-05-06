//
//  DetailCell2.m
//  Teshehui
//
//  Created by apple_administrator on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "DetailCell2.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIView+Frame.h"
@implementation DetailCell2

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreen_Width - 20, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"0x424242"]];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"0x606060"]];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [self.contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)bindata:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)index{

    
    if (baseInfo == nil) {
        return;
    }
    _baseInfo = baseInfo;
    _index = index;
    
    switch (index) {
        case 0:
        {
             [_titleLabel setText:@"营业时间"];
            if (baseInfo.IsAllDay == 1) {
               
                [_contentLabel setText:@"24小时营业"];
                
            }else{
                
                NSMutableArray *array =  nil ;
                if (baseInfo.OpeningHours != nil) {
                    NSData *obj =   [baseInfo.OpeningHours dataUsingEncoding:NSUTF8StringEncoding];
                    array =  [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
                }
                
                if (array.count == 1) {
                    [_contentLabel setText:array[0]];
                }else if(array.count == 2){
                    [_contentLabel setText:[NSString stringWithFormat:@"%@  %@",array[0],array[1]]];
                }else if (array.count == 3){
                    [_contentLabel setText:[NSString stringWithFormat:@"%@  %@  %@",array[0],array[1],array[2]]];
                }else{
                    [_contentLabel setText:@""];
                }
                
            }
            [_contentLabel setFrame:CGRectMake(10, 35, kScreen_Width - 20, 20)];
            
        }
            break;
        case 1:
        {
            [_titleLabel setText:@"通用价格策略"];
            [_contentLabel setText:baseInfo.Common_Strategy];
            CGSize tmpSize;
            
            tmpSize = [baseInfo.Common_Strategy sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreen_Width - 20 , 1000000)];
            [_contentLabel setFrame:CGRectMake(10, 35, kScreen_Width - 20, tmpSize.height)];

        }
            break;
        case 2:
        {
            [_titleLabel setText:@"价格策略"];
            [_contentLabel setText:baseInfo.Strategy];
            CGSize tmpSize;
            
            tmpSize = [baseInfo.Strategy sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreen_Width - 20 , 1000000)];
            [_contentLabel setFrame:CGRectMake(10, 35, kScreen_Width - 20, tmpSize.height)];
        }
            break;
        case 3:
        {
            [_titleLabel setText:@"简介"];
            
            if(baseInfo.MDescription.length != 0){
                //设置帖子内容的行距
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:baseInfo.MDescription];;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                [paragraphStyle setLineSpacing:8];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, baseInfo.MDescription.length)];
                _contentLabel.attributedText = attributedString;

            }
            
            if (_baseInfo.Refresh) {
                
              //  CGSize size = [baseInfo.MDescription sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreen_Width - 20 , 1000000)];
               
                //调节高度
                _tmpSize = [_contentLabel sizeThatFits:CGSizeMake(kScreen_Width - 20 , 1000000)];
                
                _contentLabel.numberOfLines = 0;
                [_contentLabel setFrame:CGRectMake(10, 35, kScreen_Width - 20, _tmpSize.height)];

                if (!_btn) {
                    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [_btn setImage:[UIImage imageNamed:@"icon_moreupgray"] forState:UIControlStateNormal];
                    [_btn setFrame:CGRectMake(10, _contentLabel.y + _contentLabel.height + 5, kScreen_Width - 20, 20)];
                    [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.contentView addSubview:_btn];
                }

            } else {
                
               // _tmpSize = [baseInfo.MDescription sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(kScreen_Width - 20 , 1000000)];
                
                //调节高度
                _tmpSize = [_contentLabel sizeThatFits:CGSizeMake(kScreen_Width - 20 , 1000000)];
                
                _contentLabel.numberOfLines =  125 ? 8 : 0;
                [_contentLabel setFrame:CGRectMake(10, 35, kScreen_Width - 20,_tmpSize.height > 125 ? 125 : _tmpSize.height)];
                
                if (_tmpSize.height > 125) {
                    if (!_btn) {
                        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
                        [_btn setImage:[UIImage imageNamed:@"icon_moregray"] forState:UIControlStateNormal];
                        [_btn setFrame:CGRectMake(10, _contentLabel.y + _contentLabel.height + 5, kScreen_Width - 20, 20)];
                        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                        [self.contentView addSubview:_btn];
                    }
                }
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)btnAction:(UIButton *)btn{
    _baseInfo.Refresh = !_baseInfo.Refresh;
    if (_btnClickBlock) {
        _btnClickBlock(_baseInfo,_btn);
    }
}

- (CGFloat)cellHeight{
    if (_index == 3 && _tmpSize.height > 125) {
         return 45 + _contentLabel.height + 20;
    }else{
        return 45 + _contentLabel.height;
    }
}

@end
