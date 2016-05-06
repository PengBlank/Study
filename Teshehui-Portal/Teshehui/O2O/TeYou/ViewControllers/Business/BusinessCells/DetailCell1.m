//
//  DetailCell1.m
//  Teshehui
//
//  Created by apple_administrator on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "DetailCell1.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIView+Frame.h"
@implementation DetailCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setText:@"总体评价"];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"0x606060"]];
        [self.contentView addSubview:_titleLabel];
        
        _starView = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(70, 10, 100, 30) andStars:5 isFractional:YES];
        _starView.userInteractionEnabled = NO;
        _starView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_starView];
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 10, 50, 30)];
        [_scoreLabel setFont:[UIFont systemFontOfSize:15]];
        [_scoreLabel setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
        [self.contentView addSubview:_scoreLabel];
        
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[UIFont systemFontOfSize:14]];
        [_countLabel setTextColor:[UIColor colorWithHexString:@"0x606060"]];
        [self.contentView addSubview:_countLabel];
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 20, 18, 10, 14)];
        [_imageV setImage:IMAGE(@"arrowright")];
        [self.contentView addSubview:_imageV];

        
    }
    return self;
}

-  (void)bindDataWithDetailSection1:(BusinessdetailInfo *)info{
    if (info == nil) {
        return;
    }
    
    if (info.CommentCount == 0) {
      //  self.accessoryType = UITableViewCellAccessoryNone;
        _scoreLabel.hidden = YES;
        _countLabel.hidden = YES;
        _imageV.hidden = YES;
    }else{
//        _scoreLabel.hidden = NO;
//        _countLabel.hidden = NO;
        
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         _starView.rating = info.AverageStars;
        [_scoreLabel setText:[NSString stringWithFormat:@"%@分",@(info.AverageStars)]];
        
        CGSize tmpSize;
        NSString *tmpStr = [NSString stringWithFormat:@"共%@条评价",@(info.CommentCount)];
        tmpSize = [tmpStr sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 200 , 30)];
        [_countLabel setFrame:CGRectMake(kScreen_Width - tmpSize.width - g_fitFloat(@[@22.5,@25,@30]), 10, tmpSize.width, 30)];
        [_countLabel setText:tmpStr];
    }
    


}


@end
