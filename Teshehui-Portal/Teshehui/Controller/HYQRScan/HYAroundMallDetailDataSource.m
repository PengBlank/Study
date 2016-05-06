//
//  HYAroundMallDetailDataSource.m
//  Teshehui
//
//  Created by RayXiang on 14-7-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundMallDetailDataSource.h"
#import "HYQRCodeGetShopDetailResponse.h"
#import "HYBaseLineCell.h"
#import "HYAroundMallSummaryCell.h"
#import "HYAroundMallAddressCell.h"
#import "HYAroundMallDetailCell.h"
#import "MWPhotoBrowser.h"
#import "HYQRCodeGetShopListResponse.h"
#import "PTHttpManager.h"
#import "HYUserInfo.h"

@interface HYAroundMallDetailDataSource ()
<HYAroundMallSummaryCellDelegate,
MWPhotoBrowserDelegate>

@property (nonatomic, strong) UIWebView *detailWeb;
@property (nonatomic, assign) BOOL webLoaded;

@end

@implementation HYAroundMallDetailDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)rowHeightForIndexPath:(NSIndexPath *)idxPath
{
    if (idxPath.section == 0)
    {
        return 135;
    }
    else if (idxPath.section == 1)
    {
        return 44;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            return [self summaryCellForTableView:tableView];
            break;
        }
        case 1:
        {
            return [self addressCellForTableView:tableView];
            break;
        }
//        case 2:
//        {
//            return [self detailCellForTableView:tableView];
//            break;
//        }
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)summaryCellForTableView:(UITableView *)table
{
    static NSString *identifier = @"summaryCell";
    HYAroundMallSummaryCell *summaryCell = (HYAroundMallSummaryCell *)[table dequeueReusableCellWithIdentifier:identifier];
    [summaryCell setWithShopDetail:_shopDetail];
    summaryCell.delegate = self;
    return summaryCell;
}

- (void)telBtnAction:(id)sender
{
    if (self.telBtnCallback)
    {
        self.telBtnCallback(sender);
    }
}

- (void)summaryCellDidClickPhoto
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    for (NSString *p in _shopDetail.img_url)
    {
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p]]];
    }
    
    self.photos = photos;
    
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
    [self.viewController.navigationController pushViewController:browser animated:YES];
}

- (void)summaryCellDidClickBigPhoto
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    for (NSString *p in _shopDetail.img_url)
    {
        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p]]];
    }
    
    self.photos = photos;
    
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
    [self.viewController.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    DebugNSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (UITableViewCell *)addressCellForTableView:(UITableView *)tableView
{
    static NSString *identifier = @"addr";
    HYAroundMallAddressCell *addressCell = (HYAroundMallAddressCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!addressCell)
    {
        addressCell = [[HYAroundMallAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    addressCell.textLabel.numberOfLines = 0;
    addressCell.textLabel.text = self.shopDetail.address;
    addressCell.selectionStyle = UITableViewCellSelectionStyleGray;
    addressCell.iconView.image = [UIImage imageNamed:@"icon_hotel_address"];
    [addressCell.telBtn addTarget:self action:@selector(telBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return addressCell;
}

/*
- (UITableViewCell *)detailCellForTableView:(UITableView *)tableView
{
    static NSString *identifier = @"detail";
    HYBaseLineCell *detailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!detailCell)
    {
        detailCell = [[HYBaseLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 500)];
        [detailCell.contentView addSubview:web];
        self.detailWeb = web;
        _webLoaded = NO;
    }
    
    if (!_webLoaded)
    {
        NSString *shopurl = [NSString stringWithFormat:@"%@/api/merchant/get_merchant_info?merchant_id=%ld", kMallRequestBaseURL, _shopDetail.store_id];
        PTHttpManager *mg = [PTHttpManager getInstantane];
        NSString *user_id = [NSString stringWithFormat:@"user_id=%@",[[HYUserInfo getUserInfo] userId]];
        NSString *appkey = [NSString stringWithFormat:@"app_key=%@", [mg appKey]];
        NSString *token = [NSString stringWithFormat:@"token=%@", [HYUserInfo getUserInfo].token];
        
        NSString *timestamp = [mg timestamp];
        NSString *signature = [mg getSigantureWittTimestpamp:timestamp];
        signature = [NSString stringWithFormat:@"signature=%@", signature];
        timestamp = [NSString stringWithFormat:@"timestamp=%@", timestamp];
        
        NSMutableString *str = [NSMutableString string];
        if ([appkey length] > 0 && [timestamp length] > 0 && [signature length] > 0 && [token length] > 0)
        {
            [str appendString:appkey];
            [str appendString:[NSString stringWithFormat:@"&%@", timestamp]];
            [str appendString:[NSString stringWithFormat:@"&%@", signature]];
            [str appendString:@"&app_from=IOS"];
            [str appendString:[NSString stringWithFormat:@"&%@", user_id]];
            [str appendString:[NSString stringWithFormat:@"&%@", token]];
            
            NSURL* parsedURL = [NSURL URLWithString:shopurl];
            NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
            
            NSString *url = [NSString stringWithFormat:@"%@%@%@", shopurl, queryPrefix, str];
            url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            
            [_detailWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
            _detailWeb.delegate = self;
            _webLoaded = YES;
        }
    }

    return detailCell;
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    //if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    //}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DebugNSLog(@"web finished");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DebugNSLog(@"web error!%@", error.domain);
}

@end
