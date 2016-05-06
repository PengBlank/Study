    //
//  HYSplitViewController+UmengShake.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-6.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYSplitViewController+UmengShake.h"
#import "HYDataManager.h"

@implementation HYSplitViewController (UmengShake)

- (void)umengShake
{
    if ([HYDataManager sharedManager].userInfo.organType == OrganTypePromoter)
    {
        if (!_isShare)
        {
            [UMSocialShakeService setShakeThreshold:1.2];
            [UMSocialShakeService setShakeToShareWithTypes:nil
                                                 shareText:nil
                                              screenShoter:nil
                                          inViewController:nil
                                                  delegate:self];
        }
    }
}

- (void)stopShake
{
    if ([HYDataManager sharedManager].userInfo.organType == OrganTypePromoter)
    {
        [UMSocialShakeService unShakeToSns];
    }
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType;
{
    _isShare = NO;
}

-(UMSocialShakeConfig)didShakeWithShakeConfig
{
    if (!_isShare)
    {
        _isShare = YES;
        
        //UMSocialWXMessageTypeImage 为纯图片类型
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
        
        NSString *title = @"我发现了一款超赞的应用《特奢汇》";
        NSString *content = nil;
        if (self.inviteCode.length > 0)
        {
            content = [NSString stringWithFormat:kUMengShareContentPromoter, self.inviteCode];
            title = [title stringByAppendingFormat:@"邀请码:%@", self.inviteCode];
        }
        else
        {
            content = kUMengShareContent;
        }
        [UMSocialData defaultData].extConfig.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.hy.teshehui&g_f=991653";
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UMengKey
                                          shareText:content
                                         shareImage:[UIImage imageNamed:@"icon_tsh.png"]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToEmail,UMShareToSms,UMShareToTencent,nil]
                                           delegate:self];
        //下面返回值控制是否显示分享编辑页面、是否显示截图、是否有音效，UMSocialShakeConfigNone表示都不显示
        return UMSocialShakeConfigSound;
    }
    else
    {
        return UMSocialShakeConfigNone;
    }
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
