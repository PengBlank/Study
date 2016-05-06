//
//  BusinessDetailCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinessDetailCell.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIView+Frame.h"
@implementation BusinessDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
      
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 10, 20)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"0x424242"]];
        //[_titleLabel setBackgroundColor:[UIColor purpleColor]];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"0x606060"]];
        [self.contentView addSubview:_contentLabel];

        WS(weakSelf);

        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
            make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
            make.top.mas_equalTo(_titleLabel.mas_top);
        }];
    }
    return self;
}


- (void)bindData:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)indexPath{
    
    _index = indexPath;
        if (baseInfo == nil) {
            return;
        }
        switch (indexPath) {
            case 1:
            {
                [_titleLabel setWidth:60];
                if (baseInfo.IsAllDay == 1) {
                     [_titleLabel setText:@"营业时间"];
                    [_contentLabel setText:@"24小时营业"];
                
                }else{
                    
                    NSMutableArray *array =  nil ;
                    if (baseInfo.OpeningHours != nil) {
                        NSData *obj =   [baseInfo.OpeningHours dataUsingEncoding:NSUTF8StringEncoding];
                        array =  [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingMutableContainers error:nil];
                    }
                    
                    [_titleLabel setText:@"营业时间"];
                    
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

            }
                break;
            case 2:
            {

                [_titleLabel setWidth:95];
                [_titleLabel setText:@"通用价格策略"];
                
                
                [_contentLabel setText:baseInfo.Common_Strategy];
                string = _contentLabel.text == nil ? @"呵呵" : baseInfo.Common_Strategy;
            }
                break;
            case 3:
            {
                
                [_titleLabel setWidth:60];
                [_titleLabel setText:@"价格策略"];
                [_contentLabel setText:baseInfo.Strategy];
                string = _contentLabel.text == nil ? @"呵呵" : baseInfo.Strategy;
            }
                break;
            case 4:
            {
                [_titleLabel setWidth:60];
                [_titleLabel setText:@"简介"];
                [_contentLabel setText:baseInfo.MDescription];
                string = _contentLabel.text == nil ? @"呵呵" : baseInfo.MDescription;
            
            }
                break;

            default:
                break;
    }
    
}

- (CGFloat)cellHeight{
    
    if (_index == 4) {
        
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 15 - 95 - 20 , 100000)];
        return size.height + 30;
    }else if(_index == 2){
       
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 15 - 95 - 15 , 100000)];
        return size.height + 30;
    }else{
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 15 - 60 - 15 , 100000)];
        return size.height + 30;
    }
    

}


@end
