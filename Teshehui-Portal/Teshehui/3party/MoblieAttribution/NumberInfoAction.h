//
//  NumberInfoAction.h
//  ContactHub
//
//  Created by ChengQian on 13-6-5.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#ifndef __ContactHub__NumberInfoAction__
#define __ContactHub__NumberInfoAction__



#include <iostream>
#include <string.h>

#include "AreaArray.h"
#include "NumberInfoCompress.h"

const int MaxCityLength = 25;

class NumberInfoAction{
private:
	// -------------------------------------------------------
	//  Name:         GetCityIndexByCityName
	//  Description:  Get city index from the array<char*>, if can not
	//                the city, insert the city, then, return the index
	//  Arguments:    city name
	//  Return Value: city index
	// -------------------------------------------------------
	int GetCityIndexByCityName(char* cityName);
	void WriteCities( FILE* outFile );
	void WriteRecords(FILE* inFile, int &phoneInfoCompressCount, FILE* outFile );
	char* DoFindResultThing( FILE* file,const int& phoneInfoCompressCount,const NumberInfoCompress &infoMiddle );
    
public:
	NumberInfoAction():cities(500),preCityIndex(0){
        
	}
	~NumberInfoAction(){
        
        //此处析构是多余的 by chengqian
        /*
        if (cities != 0 )
        {
            delete[] cities;
        }
         */
	}
	//vector<char*> getLocationInfo() const{return cities;}
	AreaArray<char*> getLocationInfo() const{return cities;}
    
	// -------------------------------------------------------
	//  Name:         GetCityNameByNumber
	//  Description:  input the phone number, find the city in the binary file
	//  Arguments:    bFileName:the binary file name,number: the phone number
	//  Return Value: city name,not find return ""
	// -------------------------------------------------------
	char* GetCityNameByNumber(const char* bFileName,const int number);
    
	// -------------------------------------------------------
	//  Name:         ChangeTxtToBinary
	//  Description:  Read every line in txt file, convert it to special customized format
	//                binary file.
	//                binary file content: count of total records, records, cities
	//  Arguments:    txt file name, binary file name
	//  Return Value: true means success
	// -------------------------------------------------------
	bool ChangeTxtToBinary(const char* inFileName,const char* outFileName);
    
private:
    //vector<char*> cities;
    AreaArray<char*> cities;
    int preCityIndex ;
};

#endif /* defined(__ContactHub__NumberInfoAction__) */
