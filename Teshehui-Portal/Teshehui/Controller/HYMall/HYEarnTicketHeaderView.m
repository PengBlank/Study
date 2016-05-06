//
//  HYEarnTicketHeaderView.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYEarnTicketHeaderView.h"
#import "MDHTMLLabel.h"

@implementation HYEarnTicketHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _content = [[MDHTMLLabel alloc] init];
        _content.backgroundColor = [UIColor clearColor];
        _content.textColor = [UIColor colorWithWhite:.5 alpha:1];
        _content.font = [UIFont systemFontOfSize:15.0];
        _content.linkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                    NSUnderlineStyleAttributeName: [NSNumber numberWithBool:YES]};
        _content.htmlText = @"升级为付费会员即可获得等额现金券 <a href='update'>立即升级</a>";
        _content.textAlignment = NSTextAlignmentCenter;
        _content.delegate = self;
        [self addSubview:_content];
    }
    return self;
}

- (void)layoutSubviews
{
    _content.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)HTMLLabel:(MDHTMLLabel *)label didSelectLinkWithURL:(NSURL*)URL
{
    if ([[URL absoluteString] isEqualToString:@"update"])
    {
//        HYShareGetPointViewController *share = [[HYShareGetPointViewController alloc] initWithNibName:@"HYShareGetPointViewController" bundle:nil];
//        [self.navigationController pushViewController:share animated:YES];
        if (self.didClickUpdate)
        {
            self.didClickUpdate();
        }
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
