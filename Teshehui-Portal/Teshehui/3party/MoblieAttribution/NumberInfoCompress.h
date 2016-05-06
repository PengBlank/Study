//
//  NumberInfoCompress.h
//  ContactHub
//
//  Created by ChengQian on 13-6-5.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#ifndef __ContactHub__NumberInfoCompress__
#define __ContactHub__NumberInfoCompress__

#include <iostream>
class NumberInfoCompress{
    
public:
	NumberInfoCompress():m_before(0),m_after(0),m_cityIndex(0){
	}
	NumberInfoCompress(int begin,unsigned short skip,unsigned short cityIndex)
	{
		setBegin(begin);
		setSkip(skip);
		m_cityIndex = cityIndex;
	}
	int getBegin(){
		int lastTwoNumInAfter = m_after - getNumExceptLastTwo() * 100;
		return m_before * 100 + lastTwoNumInAfter;
	}
	unsigned short getNumExceptLastTwo(){return m_after * 0.01;}
	unsigned short getSkip(){ return getNumExceptLastTwo(); }
	unsigned short getCityIndex()const{ return m_cityIndex; }
	unsigned short getLastTwoNum(int number){
		int exceptLastTwoNum = number * 0.01;
		return (number - exceptLastTwoNum * 100);
	}
	void setBegin(int& number){
		int lastTwoNum = getLastTwoNum(number);
		m_before = number * 0.01;
		m_after = getSkip() * 100 + lastTwoNum;
	}
	void setSkip(unsigned short skip){
        m_after =	skip * 100 + getLastTwoNum(m_after);
	}
	void setCityIndex(unsigned short& city){m_cityIndex = city;}
private:
	unsigned short m_before;//store the 5 digit of the number,example: it store 136700 of 1367002
	
	unsigned short m_after;//store skip and last two digit of the number,
    //example:102,means 1 is the skip,02 is the last two digit of the number(1367002)
	unsigned short  m_cityIndex;
    
};

#endif /* defined(__ContactHub__NumberInfoCompress__) */

//转换dat文件
/*
 NSString *infile = [[NSBundle mainBundle] pathForResource:@"mobile_201309"
 ofType:@"txt"];
 
 const char * c_infile = [infile cStringUsingEncoding:NSUTF8StringEncoding];
 
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
 NSString *outfile = [basePath stringByAppendingPathComponent:@"tele_area.dat"];
 
 const char * c_outfile = [outfile cStringUsingEncoding:NSUTF8StringEncoding];
 
 NSLog(@"开始数据转换");
 NumberInfoAction *action = new NumberInfoAction;
 action->ChangeTxtToBinary(c_infile, c_outfile);
 
 NSLog(@"开始查找");
 char *name = action->GetCityNameByNumber(c_outfile, 1868212);
 NSString *str = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
 NSLog(@"区域是：%@", str);
 
 free(action);
*/