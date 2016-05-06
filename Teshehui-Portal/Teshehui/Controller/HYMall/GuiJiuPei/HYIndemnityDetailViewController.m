//
//  HYIndemnityDetailViewController.m
//  Teshehui
//
//  Created by Fei Wang on 15-3-31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYIndemnityDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface HYIndemnityDetailViewController ()

@end

@implementation HYIndemnityDetailViewController

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"申赔详情";
    
    [self initvView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private methods
- (void)initvView
{
    //_contentView
    _contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _contentView.contentSize = CGSizeMake(self.view.bounds.size.width,
                                          self.view.bounds.size.height+1);
    [self.view addSubview:_contentView];
    
    //image
    UILabel *imageLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 14, 140, 16)];
    imageLab.font = [UIFont systemFontOfSize:15];
    imageLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    imageLab.backgroundColor = [UIColor clearColor];
    imageLab.textAlignment = NSTextAlignmentLeft;
    imageLab.text = [NSString stringWithFormat:@"已成功上传%ld张图片", [self.indemnityInfo.imgs count]];
    [_contentView addSubview:imageLab];
    
    int index = 0;
    for (NSString *url in self.indemnityInfo.imgs)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+TFScalePoint(92)*index,
                                                                               46,
                                                                               TFScalePoint(72),
                                                                               TFScalePoint(72))];
        [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                     placeholderImage:nil];
        [_contentView addSubview:imageView];
        index++;
    }
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 1)];
    topLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
    [_contentView addSubview:topLine];
    
    //product link
    UILabel *linkLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 140, 16)];
    linkLab.font = [UIFont systemFontOfSize:15];
    linkLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    linkLab.backgroundColor = [UIColor clearColor];
    linkLab.textAlignment = NSTextAlignmentLeft;
    linkLab.text = @"已成功上传商品链接";
    [_contentView addSubview:linkLab];
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    CGSize size = [self.indemnityInfo.compareURL sizeWithFont:font
                                            constrainedToSize:CGSizeMake(TFScalePoint(280), MAXFLOAT)];
    
    UITextView *linkView = [[UITextView alloc] initWithFrame:CGRectMake(16, 184, size.width+14, size.height+20)];
    linkView.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    linkView.font = font;
    linkView.backgroundColor = [UIColor clearColor];
    linkView.text = self.indemnityInfo.compareURL;
    [linkView setEditable:NO];
    linkView.scrollEnabled = NO;
    [_contentView addSubview:linkView];
    
    UIView *mLine = [[UIView alloc] initWithFrame:CGRectMake(0, 200+size.height, self.view.frame.size.width, 1)];
    mLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
    [_contentView addSubview:mLine];
    
    //desc
    UILabel *descLab1 = [[UILabel alloc] initWithFrame:CGRectMake(20, mLine.frame.origin.y+14, 140, 16)];
    descLab1.font = [UIFont systemFontOfSize:15];
    descLab1.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    descLab1.backgroundColor = [UIColor clearColor];
    descLab1.textAlignment = NSTextAlignmentLeft;
    descLab1.text = @"已成功上传申赔说明";
    [_contentView addSubview:descLab1];
    
    font = [UIFont systemFontOfSize:14.0f];
    size = [self.indemnityInfo.desc sizeWithFont:font
                               constrainedToSize:CGSizeMake(TFScalePoint(270), MAXFLOAT)];
    
    UIImageView *descBgView = [[UIImageView alloc] initWithFrame:CGRectMake(20,
                                                                            mLine.frame.origin.y+40,
                                                                            TFScalePoint(280),
                                                                            size.height+20)];
    descBgView.image = [[UIImage imageNamed:@"g_bj"] stretchableImageWithLeftCapWidth:60
                                                                         topCapHeight:20];
    
    UILabel *descLab2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, size.width, size.height+4)];
    descLab2.font = [UIFont systemFontOfSize:14];
    descLab2.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    descLab2.backgroundColor = [UIColor clearColor];
    descLab2.textAlignment = NSTextAlignmentLeft;
    descLab2.lineBreakMode = NSLineBreakByCharWrapping;
    descLab2.numberOfLines = 10;
    descLab2.text = self.indemnityInfo.desc;
    [descBgView addSubview:descLab2];
    
    [_contentView addSubview:descBgView];
    
    UIView *buttomLine = [[UIView alloc] initWithFrame:CGRectMake(0,descBgView.frame.origin.y+size.height+30, self.view.frame.size.width, 1)];
    buttomLine.backgroundColor = [UIColor colorWithWhite:0.82 alpha:1.0];
    [_contentView addSubview:buttomLine];
}

@end
