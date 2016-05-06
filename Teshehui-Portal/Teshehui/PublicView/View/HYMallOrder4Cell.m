//
//  HYMallOrder4Cell.m
//  Teshehui
//
//  Created by ichina on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrder4Cell.h"

@implementation HYMallOrder4Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
        UILabel* spLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
        spLab.backgroundColor = [UIColor clearColor];
        spLab.text = @"消耗金钱:";
        spLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:spLab];
        
        _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 180, 20)];
        _moneyLab.textAlignment = NSTextAlignmentRight;
        _moneyLab.backgroundColor = [UIColor clearColor];
        _moneyLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_moneyLab];
        
        
        UILabel* ptLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 100, 20)];
        ptLab.backgroundColor = [UIColor clearColor];
        ptLab.text = @"消耗现金券:";
        ptLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:ptLab];
        
        _pointLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 25, 180, 20)];
        _pointLab.textAlignment = NSTextAlignmentRight;
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview: _pointLab];
        
        
    }
    return self;
}
-(void)setList:(NSDictionary *)dic
{
    _moneyLab.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"money"]];
    _pointLab.text = [dic objectForKey:@"point"];
}


@end
