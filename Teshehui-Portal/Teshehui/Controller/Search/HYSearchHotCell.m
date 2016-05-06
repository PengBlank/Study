//
//  HYSearchHotCell.m
//  Teshehui
//
//  Created by apple on 15/1/23.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSearchHotCell.h"
#import "HYSearchHotKeyResponse.h"

@interface HYSearchHotCell ()
//@property (nonatomic,strong) UILabel *
@end

@implementation HYSearchHotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.separatorLeftInset = 0;
        self.textLabel.font = [UIFont systemFontOfSize:14.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15,
                                      10,
                                      self.imageView.frame.size.width,
                                      self.imageView.frame.size.height);
    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10,
                                      self.imageView.frame.origin.y,
                                      300,
                                      self.imageView.frame.size.height);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHotItems:(NSArray *)hotItems
{
    if (_hotItems != hotItems)
    {
        _hotItems = hotItems;
        
        if (_hotItems.count > 0)
        {
            CGFloat l = 15;
            CGFloat r = 10;
            CGFloat w = CGRectGetWidth(self.frame);
            UIFont *font = [UIFont systemFontOfSize:13.0];
            CGFloat x = l;
            CGFloat y = 30;
            UIButton *lastBtn = nil;
            
            for (int i = 0; i < _hotItems.count; i++)
            {
                HYSearchHotKey *hot = [_hotItems objectAtIndex:i];
                NSString *key = hot.keyword;
                CGSize size = [key sizeWithFont:font constrainedToSize:CGSizeMake((w-l-r), font.lineHeight)];
                if (size.width + 20 + 10 + x + r > w)   //左右20 ，间隔10
                {
                    x = l;
                    y += size.height + 14;
                }
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, size.width+20, 24)];
                [btn setTitle:key forState:UIControlStateNormal];
                btn.titleLabel.font = font;
                [btn setTitleColor:[UIColor colorWithWhite:.73 alpha:1] forState:UIControlStateNormal];
                btn.layer.borderColor = [UIColor colorWithWhite:.8 alpha:1].CGColor;
                btn.layer.borderWidth = 1.0;
                btn.layer.cornerRadius = 2.0;
                btn.tag = 1000 + i;
                [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:btn];
                
                x += 10 + size.width + 20;
                
                lastBtn = btn;
            }
            
            CGRect frame = self.frame;
            frame.size.height = CGRectGetMaxY(lastBtn.frame) + 10;
            self.frame = frame;
        }
        else
        {
            CGRect frame = self.frame;
            frame.size.height = 44;
            self.frame = frame;
        }
    }
}

- (void)btnAction:(UIButton *)btn
{
    NSInteger i = btn.tag - 1000;
    if (i < _hotItems.count)
    {
        if (self.hotCellCallback)
        {
            self.hotCellCallback([_hotItems objectAtIndex:i]);
        }
    }
}

@end
