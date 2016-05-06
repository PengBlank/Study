//
//  HYProductComparePriceView.m
//  Teshehui
//
//  Created by Kris on 15/9/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductComparePriceView.h"
#import "HYComparePriceCell.h"
#import "Masonry.h"
#import "HYImageInfo.h"
#import "UIImageView+WebCache.h"
#import "HYNewComparePriceCell.h"
#import <WebKit/WebKit.h>
#import "HYMallWebViewController.h"
#import <SafariServices/SafariServices.h>

const NSInteger TableHeaderViewHeight = 120;

//int *const tableHeaderViewWidth= 300;

@interface HYProductComparePriceView()
<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    UIButton *_buyNowBtn;
    UIButton *_addShoppingCarBtn;
    
    NSInteger _tableHeaderViewWidth;
}

@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *comparePrice;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *cashTicketLab;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UIButton *close;

@end

@implementation HYProductComparePriceView

+ (instancetype)instanceView
{
    UINib *nib = [UINib nibWithNibName:@"HYProductComparePriceView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views.count > 0)
    {
        return [views objectAtIndex:0];
    }
    return nil;
}

- (void)show
{
    if (!self.superview)
    {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        self.frame = [UIScreen mainScreen].bounds;
        [window addSubview:self];
    }
    
    __weak typeof(self) b_self = self;
    b_self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        b_self.alpha = 1;
    }];
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    _alphaView.frame = CGRectMake(0, 0, TFScalePoint(320), size.height);
    
//    UIButton *close = [UIButton buttonWithType:UIButtonTypeCustom];
//    close.frame = TFRectMake(270, 0, 40, 40);
//    [close setImage:[UIImage imageNamed:@"sheng_close"] forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
//    [_baseView addSubview:close];

    //tableview
    _tableHeaderViewWidth = TFScalePoint(300);
    CGRect frame = CGRectMake(TFScalePoint(10), ScreenRect.size.height-TableHeaderViewHeight-TFScalePoint(44), _tableHeaderViewWidth, TableHeaderViewHeight);
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:frame
                                                         style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.userInteractionEnabled = YES;
    tableview.rowHeight = 45;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [tableview registerClass:[HYNewComparePriceCell class] forCellReuseIdentifier:@"ComparePriceCell"];
    /*
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFScalePoint(310), 100)];
    tableview.tableHeaderView = header;
     */
    tableview.sectionHeaderHeight = TableHeaderViewHeight;
    _baseView.frame = CGRectMake(0, 0, _tableHeaderViewWidth, TableHeaderViewHeight);
    [self addSubview:tableview];
    self.tableView = tableview;
    
    
    /* //I dont know why it doesnt work
     
    self.autoresizingMask = UIViewAutoresizingNone;
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(300);
        make.left.equalTo(weakSelf).with.offset(TFScalePoint(5));
        make.right.equalTo(weakSelf).with.offset(TFScalePoint(-5));
        make.bottom.equalTo(weakSelf).with.offset(-50);
    }];
     */
    _buyNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buyNowBtn setFrame:CGRectMake(size.width * 0.5, size.height-TFScalePoint(44), size.width * 0.5, TFScalePoint(44))];
    [_buyNowBtn setBackgroundColor:[UIColor colorWithRed:216.0/255.0
                                                   green:42.0/255.0
                                                    blue:46.0/255.0
                                                   alpha:1.0]];
    [_buyNowBtn setTitle:@"立即购买"
                forState:UIControlStateNormal];
    [_buyNowBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_buyNowBtn addTarget:self
                   action:@selector(buyNowEvent:)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buyNowBtn];
    
    _addShoppingCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addShoppingCarBtn setFrame:CGRectMake(0, size.height-TFScalePoint(44), size.width * 0.5, TFScalePoint(44))];
    [_addShoppingCarBtn setTitle:@"加入购物车"
                        forState:UIControlStateNormal];
    [_addShoppingCarBtn setBackgroundColor:[UIColor colorWithRed:235.0/255.0
                                                           green:155.0/255.0
                                                            blue:40.0/255.0
                                                           alpha:1.0]];
    [_addShoppingCarBtn setTitleColor:[UIColor whiteColor]
                             forState:UIControlStateNormal];
    [_addShoppingCarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_addShoppingCarBtn addTarget:self
                           action:@selector(addToShoppingCarEvent:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addShoppingCarBtn];
    
    //header
    _productImageView.clipsToBounds = YES;
    _productImageView.frame = CGRectMake(10, 35, 60, 60);
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)dismiss
{
    __weak typeof(self) b_self = self;
    [UIView animateWithDuration:.3 animations:^
     {
         b_self.alpha = 0;
     } completion:^(BOOL finished)
     {
         [b_self removeFromSuperview];
     }];
}

#pragma mark private methods
/*
- (void)showNullView
{
    self.nullView.hidden = NO;
    
    CGRect frame = CGRectMake(TFScalePoint(5), ScreenRect.size.height-155-TFScalePoint(44)-TFScalePoint(40), TFScalePoint(310), 150);
    
    //tableview上贴一个隐藏的nullview
    _nullView = [[HYComparePriceNullView alloc]initWithFrame:
                 CGRectMake(TFScalePoint(5), ScreenRect.size.height-TFScalePoint(44)-TFScalePoint(40)-5, TFScalePoint(310), TFScalePoint(40))];
    _nullView.backgroundColor = [UIColor whiteColor];
    
    //line
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(TFScalePoint(5), ScreenRect.size.height-TFScalePoint(44)-TFScalePoint(40)-5, TFScalePoint(310), 1)];
    line.backgroundColor = [UIColor colorWithWhite:.93 alpha:1.0];
    [self addSubview:_nullView];
    [self addSubview:line];
    
    self.tableView.frame = frame;
}
 */

- (IBAction)closeView
{
    [self dismiss];
}

#pragma mark gesture delegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    CGRect frame = [_tableView convertRect:_tableView.bounds toView:self];
    if (CGRectContainsPoint(frame, location))
    {
        return NO;
    }
    return YES;
}

#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return _baseView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.priceModel.productSKUWebPriceArray.count;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow-1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYNewComparePriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComparePriceCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([_data.priceModel.productSKUWebPriceArray count]>0)
    {
        if (indexPath.row < [_data.priceModel.productSKUWebPriceArray count])
        {
            HYProductSKUWebPriceArrayModel *cellData = _data.priceModel.productSKUWebPriceArray[indexPath.row];
            [cell setPlatFromPriceData:cellData];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([_data.priceModel.productSKUWebPriceArray count]>0)
    {
        if (indexPath.row < [_data.priceModel.productSKUWebPriceArray count])
        {
            HYProductSKUWebPriceArrayModel *cellData = _data.priceModel.productSKUWebPriceArray[indexPath.row];
            NSString *strUrl = [cellData.compareUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            //陈文涛:@程谦 @向成才 @肖晓萍 @刘彦铮_ian 有一个调整，即【比价链接用webview打开，不要跳原生系统浏览器】，请做下调整
            [self dismiss];
            
            if ([self.delegate isKindOfClass:[UIViewController class]])
            {
                HYMallWebViewController *web = [[HYMallWebViewController alloc]init];
                web.linkUrl = strUrl;
                UIViewController *vc = (UIViewController *)self.delegate;
                [[vc navigationController] pushViewController:web
                                                     animated:YES];
            }
        }
    }
}

#pragma mark HYProductDetailToolViewDelegate
- (void)buyNowEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(buyNow)])
    {
        [self closeView];
        [self.delegate buyNow];
    }
}

- (void)addToShoppingCarEvent:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(addToShoppingCar)])
    {
        [self closeView];
        [self.delegate addToShoppingCar];
    }
}

#pragma mark getter and setter
-(void)setData:(HYProductComparePriceViewModel *)data
{
    _data = data;
    
    _mainTitleLab.text = _data.detailModel.productName;
    if (_data.detailModel.currentsSUK.price.length > 0)
    {
        _priceLab.text = [NSString stringWithFormat:@"会员实付:￥%@",_data.detailModel.currentsSUK.price];
    }
    else
    {
        _priceLab.text = @"——";
    }

    _priceLab.textColor = [UIColor redColor];
    _priceLab.font = [UIFont systemFontOfSize:16];
    
    _cashTicketLab = nil;
//    _cashTicketLab.text = [NSString stringWithFormat:@"现金券可抵%@元",_data.detailModel.currentsSUK.points];
    
    //image
    if (_data.detailModel.currentsSUK.productSKUImagArray.count > 0)
    {
        HYImageInfo *image =  _data.detailModel.currentsSUK.productSKUImagArray[0];
        {
            NSString *bigUrl = [NSString stringWithFormat:@"%@_%@", image.imageUrl, ImageSizeSmall];
            if (bigUrl.length > 0)
            {
                NSURL *url = [NSURL URLWithString:bigUrl];
                if (url)
                {
                    [_productImageView sd_setImageWithURL:url];
                }
            }
        }
    }
    
    NSInteger count = _data.priceModel.productSKUWebPriceArray.count;
    
    //唐阳红说最多显示六条，超过六条就可以滑动
    CGRect frame = CGRectZero;
    if (count < 7)
    {
        frame = CGRectMake(TFScalePoint(10), ScreenRect.size.height-TableHeaderViewHeight-count*45-TFScalePoint(44)-5, _tableHeaderViewWidth, TableHeaderViewHeight+count*45);
    }
    else
    {
        frame = CGRectMake(TFScalePoint(10), ScreenRect.size.height-TableHeaderViewHeight-6*45-TFScalePoint(44)-5, _tableHeaderViewWidth, TableHeaderViewHeight+6*45);
    }

    _tableView.frame = frame;
    
    [_productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self.baseView).with.offset(10);
    }];
    
    //relayout label
    [_mainTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1).with.offset(0);
        make.left.equalTo(self.productImageView.mas_right).with.offset(10);
        make.right.equalTo(self.baseView).with.offset(-5);
        make.height.mas_equalTo(40);
    }];
    
    [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainTitleLab.mas_bottom).with.offset(6);
        make.left.equalTo(self.mainTitleLab);
    }];
    
    [_cashTicketLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLab.mas_right).with.offset(10);
        make.top.equalTo(self.mainTitleLab.mas_bottom).with.offset(5);
    }];
    
    
    [self.tableView reloadData];
}
@end
