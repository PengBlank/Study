//
//  PTSimilarUtils.m
//  Boyer-Moore
//
//  Created by ChengQian on 13-6-6.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "PTSimilarUtils.h"

@implementation PTSimilarUtils

static inline int min (int a, int b, int c)
{
    int min = a;
    a = b < c ? b : c;
    return min < a ? min : a;
}

- (float)sim:(NSString *)str1 str2:(NSString *)str2
{
    NSInteger ld = [self ld:str1 str2:str2];
    return 1-(float)ld/(float)MAX(str1.length, str1.length);
}

//按照要求拆词，返回的是连续字符
- (NSArray *)cutStringWithStep:(NSString *)sourceStr stepSize:(int)stepSize
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (sourceStr.length > stepSize)
    {
        NSRange rang = NSMakeRange(0, sourceStr.length);
        while (rang.length >= stepSize)
        {
            rang.location = 0;
            while ((rang.location+rang.length) <= sourceStr.length)
            {
                NSString *str = [sourceStr substringWithRange:rang];
                [resultArray addObject:str];
                rang.location++;
            }
            rang.length--;
        }
    }
    else
    {
        [resultArray addObject:sourceStr];
    }
    
    NSArray *array = [resultArray copy];

    return array;
}

- (NSInteger)ld:(NSString *)str1 str2:(NSString *)str2
{
    NSInteger n = str1.length;
    NSInteger m = str2.length;
    if(n == 0) {
        return m;
    }
    if(m == 0) {
        return n;
    }
    
    int d[n+1][m+1];    //矩阵
    
    int i;    //遍历str1的
    int j;    //遍历str2的
    unichar ch1;    //str1的
    unichar ch2;    //str2的
    int temp;    //记录相同字符,在某个矩阵位置值的增量,不是0就是1
    
    for(i=0; i<=n; i++) {    //初始化第一列
        d[i][0] = i;
    }
    for(j=0; j<=m; j++) {    //初始化第一行
        d[0][j] = j;
    }
    for(i=1; i<=n; i++) {    //遍历str1
        ch1 = [str1 characterAtIndex:(i-1)];
        //去匹配str2
        for(j=1; j<=m; j++) {
            ch2 = [str2 characterAtIndex:(j-1)];//str2.charAt(j-1);
            if(ch1 == ch2) {
                temp = 0;
            } else {
                temp = 1;
            }
            //左边+1,上边+1, 左上角+temp取最小
            d[i][j] = min(d[i-1][j]+1, d[i][j-1]+1, d[i-1][j-1]+temp);
        }
    }
    return d[n][m];
}


@end
