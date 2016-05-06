//
//  HYFolwerShowDetailUIViewController.m
//  Teshehui
//
//  Created by ichina on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerDetailViewController.h"
#import "HYFolwerShowPicDetailViewController.h"
#import "HYFlowerDetailRequest.h"
#import "HYFlowerDetailResponse.h"
#import "HYFlowerDetailInfo.h"
#import "UIImageView+WebCache.h"
#import "HYFolwerPicDetailCell.h"
#import "HYFlowerFillOrderViewController.h"


@interface HYFlowerDetailViewController ()
{
    HYFlowerDetailRequest *_getDetailInfoReq;
}

@property (nonatomic, strong) HYFlowerDetailInfo *flowerDetailInfo;
@property (nonatomic, strong) HYNullView* nullView;

@end

@implementation HYFlowerDetailViewController

- (void)dealloc
{
    [_getDetailInfoReq cancel];
    _getDetailInfoReq = nil;
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nullView = [[HYNullView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
    
    [self getFlowerDetail];
	
}

-(void)setMyView
{
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        CGRectGetWidth(self.view.frame),
                                                                        self.view.frame.size.height-50)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    CGFloat heigth = 245;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  self.view.frame.size.width,
                                                                  heigth)];
    
    _imageVC = [[UIImageView alloc]initWithFrame:CGRectMake(0, -60, CGRectGetWidth(self.view.frame), heigth)];
    _imageVC.backgroundColor = [UIColor clearColor];
    _imageVC.contentMode = UIViewContentModeScaleAspectFill;
    _imageVC.clipsToBounds = YES;
    
    if ([self.flowerDetailInfo.midImgList count] > 0)
    {
        NSString *imageUrl = self.flowerDetailInfo.flowerPicUrl;
        [_imageVC sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                    placeholderImage:[UIImage imageNamed:@"loading"]];
    }
    
    [headerView addSubview:_imageVC];
    
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickEventOnImage:)];
    _imageVC.userInteractionEnabled = YES;
    [_imageVC addGestureRecognizer:tapRecognizer];
    
    UIImage *bgImage = [[UIImage imageNamed:@"pink_background"] stretchableImageWithLeftCapWidth:2
                                                                                    topCapHeight:2];
    
    UIImage *lineImage = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                       topCapHeight:0];
    
    UIImageView* spe1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 185, CGRectGetWidth(self.view.frame), 4)];
    spe1.image = bgImage;
    [headerView addSubview:spe1];
    
    UILabel* makertLab = [[UILabel alloc]initWithFrame:CGRectMake(20,195, 70, 20)];
    makertLab.backgroundColor = [UIColor clearColor];
    makertLab.textColor = [UIColor colorWithRed:116.0/255.0
                                          green:114.0/255.0
                                           blue:114.0/255.0
                                          alpha:1.0];
    makertLab.font = [UIFont systemFontOfSize:14.0f];
    makertLab.text = @"网络指导价";
    [headerView addSubview:makertLab];
    
    _moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(90,195,180, 20)];
    _moneyLab.backgroundColor = [UIColor clearColor];
    _moneyLab.textColor = [UIColor colorWithRed:116.0/255.0
                                          green:114.0/255.0
                                           blue:114.0/255.0
                                          alpha:1.0];
    _moneyLab.font = [UIFont systemFontOfSize:15.0f];
    _moneyLab.text = [NSString stringWithFormat:@"¥%0.2f",[self.flowerDetailInfo.marketPrice floatValue]];
    [headerView addSubview:_moneyLab];
    
    UILabel* yhLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 50, 20)];
    yhLab.backgroundColor = [UIColor clearColor];
    yhLab.textColor = [UIColor colorWithRed:116.0/255.0
                                      green:114.0/255.0
                                       blue:114.0/255.0
                                      alpha:1.0];
    yhLab.font = [UIFont systemFontOfSize:15.0f];
    yhLab.text = @"优惠价";
    [headerView addSubview:yhLab];
    
    _vipmoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(70, 220, 140, 20)];
    _vipmoneyLab.backgroundColor = [UIColor clearColor];
    _vipmoneyLab.textColor = [UIColor colorWithRed:202.0/255.0
                                             green:21.0/255.0
                                              blue:21.0/255.0
                                             alpha:1.0];
    _vipmoneyLab.font = [UIFont boldSystemFontOfSize:18.0f];
    _vipmoneyLab.text = [NSString stringWithFormat:@"¥%0.2f",[self.flowerDetailInfo.price floatValue]];
    [headerView addSubview:_vipmoneyLab];
    
    _pointLab = [[UILabel alloc]initWithFrame:CGRectZero];
    _pointLab.backgroundColor = [UIColor colorWithRed:199.0/255.0
                                                green:24.0/255.0
                                                 blue:17.0/255.0
                                                alpha:1.0];
    _pointLab.textColor = [UIColor whiteColor];
    _pointLab.font = [UIFont systemFontOfSize:12.0f];
    _pointLab.textAlignment = NSTextAlignmentCenter;
    NSString *pointStr = [NSString stringWithFormat:@"赠送%d现金券",[self.flowerDetailInfo.points intValue]];
    CGSize size = [pointStr sizeWithFont:_pointLab.font];
    _pointLab.frame = CGRectMake(220, 220, size.width+8, 16);
    _pointLab.text = pointStr;
    [headerView addSubview:_pointLab];
    
    UIImageView* spe2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 245, CGRectGetWidth(self.view.frame), 1.0)];
    spe2.image = lineImage;
    [headerView addSubview:spe2];
    
    _floridLab = [[UILabel alloc]initWithFrame:CGRectMake(20,250,CGRectGetWidth(self.view.frame)-40,0)];
    _floridLab.backgroundColor = [UIColor clearColor];
    _floridLab.numberOfLines = 0;
    _floridLab.textColor = [UIColor colorWithRed:115.0/255.0
                                           green:115.0/255.0
                                            blue:115.0/255.0
                                           alpha:1.0];
    UIFont* font = [UIFont systemFontOfSize:12.0f];
    NSString* textstr = [NSString stringWithFormat:@"花语:\n%@",self.flowerDetailInfo.flowerLanguage];
    _floridLab.font = font;
    _floridLab.text = textstr;
    CGSize floridSize = [textstr sizeWithFont:font
                            constrainedToSize:CGSizeMake(_floridLab.frame.size.width, MAXFLOAT)
                                lineBreakMode:NSLineBreakByCharWrapping];
    _floridLab.frame = CGRectMake(20, 250, CGRectGetWidth(self.view.frame)-40, floridSize.height);
    [headerView addSubview:_floridLab];
    
    heigth += (10+floridSize.height);
    
    UIImageView* spe3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                     254+_floridLab.frame.size.height,
                                                                     CGRectGetWidth(self.view.frame),
                                                                     1.0)];
    spe3.image = lineImage;
    [headerView addSubview:spe3];
    
    UILabel* muchLab = [[UILabel alloc]initWithFrame:CGRectMake(20,spe3.frame.origin.y+1,60, 50)];
    muchLab.backgroundColor = [UIColor clearColor];
    muchLab.textColor = [UIColor colorWithRed:115.0/255.0
                                        green:115.0/255.0
                                         blue:115.0/255.0
                                        alpha:1.0];;
    muchLab.font = [UIFont systemFontOfSize:13.0f];
    muchLab.text = @"购买数量";
    [headerView addSubview:muchLab];
    
    UIButton* delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.frame = CGRectMake(80,spe3.frame.origin.y+11, 30, 30);
    [delBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_buy_cut_normal"] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_buy_cut_press"] forState:UIControlStateHighlighted];
    [delBtn addTarget:self action:@selector(Del) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:delBtn];
    
    UIImageView* muchImg = [[UIImageView alloc]initWithFrame:CGRectMake(112,spe3.frame.origin.y+11, 60, 30)];
    muchImg.image = [UIImage imageNamed:@"store_buttom_delete"];
    [headerView addSubview:muchImg];
    
    _muchLab = [[UILabel alloc]initWithFrame:muchImg.frame];
    _muchLab.backgroundColor = [UIColor clearColor];
    _muchLab.textColor = [UIColor darkTextColor];
    _muchLab.textAlignment = NSTextAlignmentCenter;
    _muchLab.text = @"1";
    [headerView addSubview:_muchLab];
    
    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(174,spe3.frame.origin.y+11, 30, 30);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_buy_add_normal"]
                      forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_buy_add_press"]
                      forState:UIControlStateHighlighted];
    [addBtn addTarget:self
               action:@selector(Add)
     forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addBtn];
    
    UIImageView* spe4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, spe3.frame.origin.y+50, CGRectGetWidth(self.view.frame), 1.0)];
    spe4.image = lineImage;;
    [headerView addSubview:spe4];
    
    heigth += (50);
    headerView.frame = CGRectMake(0,
                                  0,
                                  self.view.frame.size.width,
                                  heigth);
    
    tableView.tableHeaderView = headerView;
    
    //购买按钮
    UIButton* buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(0,
                              self.view.frame.size.height-50,
                              self.view.frame.size.width,
                              50);
    [buyBtn setBackgroundImage:bgImage
                      forState:UIControlStateNormal];
    [buyBtn addTarget:self
               action:@selector(Buy)
     forControlEvents:UIControlEventTouchUpInside];
    [buyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [buyBtn setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateNormal];
    [buyBtn setTitle:@"立即购买"
            forState:UIControlStateNormal];
    [self.view addSubview:buyBtn];
}

-(void)getFlowerDetail
{
    if (!_getDetailInfoReq)
    {
        _getDetailInfoReq = [[HYFlowerDetailRequest alloc] init];
    }
    
    _getDetailInfoReq.businessType = @"04";
    _getDetailInfoReq.productId = _produceID;
    
    [HYLoadHubView show];
    
    __weak typeof(self) b_self = self;
    [_getDetailInfoReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        HYFlowerDetailInfo *info = nil;
        if (result && [result isKindOfClass:[HYFlowerDetailResponse class]])
        {
            HYFlowerDetailResponse *response = ( HYFlowerDetailResponse *)result;
            info = response.flowerDetailInfo;
        }
        [b_self updateViewWithData:info error:error];
    }];
}

- (void)updateViewWithData:(HYFlowerDetailInfo *)info error:(NSError *)error
{
    if (!error && info)
    {
        self.flowerDetailInfo = info;
        _nullView.hidden = YES;
        [self setMyView];
    }
    else
    {
        self.nullView.hidden = NO;
        if (error)
        {
            _nullView.descInfo = @"获取鲜花详情失败，请稍后再试";
        }
        else
        {
            _nullView.descInfo = @"暂无该鲜花详细信息";
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYFolwerPicDetailCell* cell = [[HYFolwerPicDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FolwerPicDetailCell"];
    cell.separatorLeftInset = 0;
    cell.headImg.image = [UIImage imageNamed:@"store_img_image_2"];
    cell.nameLab.text = @"图文详情";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYFolwerShowPicDetailViewController* showpicdetailVC = [[HYFolwerShowPicDetailViewController alloc]init];
    showpicdetailVC.Mytitle = self.flowerDetailInfo.productName;
    
    NSString *result = [self.flowerDetailInfo.flowerDescription stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    showpicdetailVC.htmlString = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:showpicdetailVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


-(void)Del
{
    if ([_muchLab.text intValue] >= 2)
    {
        [self setQuantity:([_muchLab.text intValue] - 1)];
    }
}

-(void)Add
{
    [self setQuantity:([_muchLab.text intValue]+1)];
}

-(void)setQuantity:(NSInteger)quantuty
{
    _muchLab.text = [NSString stringWithFormat:@"%d",(int)quantuty];
}

-(void)Buy
{
    HYFlowerFillOrderViewController* finishirderVC = [[HYFlowerFillOrderViewController alloc]init];
    finishirderVC.flowerDetailInfo = self.flowerDetailInfo;
    finishirderVC.buyTotal = [_muchLab.text intValue];
    [self.navigationController pushViewController:finishirderVC
                                         animated:YES];
}

-(void)ClickEventOnImage:(id)sender
{
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < 1)
        return [MWPhoto photoWithURL:[NSURL URLWithString:_headImgUrl]];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < 1)
        return [MWPhoto photoWithURL:[NSURL URLWithString:_headImgUrl]];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    DebugNSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

@end
