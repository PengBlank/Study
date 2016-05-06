//
//  HYInfoInputButtonCell.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/22.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYInfoInputButtonCell.h"

@interface HYInfoInputButtonCell ()

@property (nonatomic, strong) UIButton *additionBtn;

@end

@implementation HYInfoInputButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:btn];
        [btn addTarget:self
                action:@selector(btnAction)
      forControlEvents:UIControlEventTouchUpInside];
        self.additionBtn = btn;
    }
    return self;
}

- (void)btnAction
{
    if (self.didClickButton) {
        self.didClickButton();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGSize imgsize = self.additionBtn.imageView.image.size;
//    self.additionBtn.frame = CGRectMake(self.frame.size.width - imgsize.width - 10,
//                                        self.frame.size.height/2 - imgsize.height/2,
//                                        imgsize.width,
//                                        imgsize.height);
    self.additionBtn.frame = CGRectMake(self.frame.size.width-45, 0, 35, self.frame.size.height);
    if (self.showName)
    {
        self.valueField.frame = CGRectMake(100,
                                           0,
                                           CGRectGetMinX(self.additionBtn.frame)-100,
                                           self.frame.size.height);
    }
    else
    {
        self.valueField.frame = CGRectMake(20,
                                           0,
                                           CGRectGetMinX(self.additionBtn.frame)-20 ,
                                           self.frame.size.height);
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
