//
//  NumberInfoAction.cpp
//  ContactHub
//
//  Created by ChengQian on 13-6-5.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

#include "NumberInfoAction.h"

int NumberInfoAction::GetCityIndexByCityName(char* cityName){
    
	//try to use the last search cityIndex to quick find.
	int maxIndex = cities.size() - 1;
	if(preCityIndex <= maxIndex && strcmp(cities[preCityIndex],cityName) == 0){
		return preCityIndex;
	}
    
	int result = -1;
	//try to find in existing cities
	for(int i = 0; i < cities.size(); ++i){
		if(strcmp(cities[i],cityName) == 0){
			result = i;
			break;
		}
	}
	//not found
	if(result == -1){
		cities.push_back(cityName);
		result = cities.size() - 1;
	}
	//store the result
	preCityIndex = result;
	return result;
}

void NumberInfoAction::WriteCities( FILE* outFile ){
	//begin to write city name
	fseek(outFile,0,SEEK_END);
	int max = 0;
	for(int i = 0; i != cities.size(); ++i){
		char* location = cities[i];
		int length = strlen(location) + 1;
		if(length > max){// try to find the "MaxCityLength"
			max = length;
		}
		//just write every city in "MaxCityLength" size
		//when we try to find a city, like find an element in an array,very quickly.
		fwrite(location,MaxCityLength,1,outFile);
	}
	//cout << "max:" << max << endl;
}

void NumberInfoAction::WriteRecords(FILE* inFile, int &phoneInfoCompressCount, FILE* outFile ){
	int number;
	unsigned short cityIndex;
	NumberInfoCompress pre;
	char* firstCityName = new char[MaxCityLength];
	fscanf(inFile,"%d,%s",&number,firstCityName);
	cityIndex = GetCityIndexByCityName(firstCityName);
	//firstly,we get the first record
	pre = NumberInfoCompress(number,0,cityIndex);
    
    char c;
    c = fgetc(inFile);
	while(!feof(inFile)){
		//start from second record
		char* cityName = new char[MaxCityLength];
		fscanf(inFile,"%d,%s",&number,cityName);
		cityIndex = GetCityIndexByCityName(cityName);
		if(number - (pre.getBegin() + pre.getSkip()) ==1
           && cityIndex == pre.getCityIndex()){
            pre.setSkip(number - pre.getBegin());//combine records to one compressed record
		}else{//new compressed record
			++phoneInfoCompressCount;
			fwrite(&pre,sizeof(NumberInfoCompress),1,outFile);
			pre = NumberInfoCompress(number,
                                     0,
                                     cityIndex);
		}
        c = fgetc(inFile);
	}
	//remember write the last record
	fwrite(&pre,sizeof(NumberInfoCompress),1,outFile);
	++phoneInfoCompressCount;
}


char* NumberInfoAction::DoFindResultThing( FILE* file,const int& phoneInfoCompressCount,const NumberInfoCompress &infoMiddle )
{
	int totalOffset = sizeof(int) + phoneInfoCompressCount*sizeof(NumberInfoCompress) + infoMiddle.getCityIndex() * MaxCityLength;
	//put the read point at the result
	fseek(file,totalOffset,SEEK_SET);
	char* location = new char[MaxCityLength];
    fread(location,MaxCityLength,1,file);
	fclose(file);
    
    int i = (int)strlen(location)-1;
    while (i>=0)
    {
        if (location[i] == '_')
        {
            location[i] = ' ';
            break;
        }
        i--;
    }
	return location;
    
}

char* NumberInfoAction::GetCityNameByNumber(const char* bFileName,const int number){
	FILE* file = 0;
	file = fopen(bFileName,"rb");
	if(file == 0)
		return (char*)"";
    
	int phoneInfoCompressCount = 0;
	//get total phoneInfoCompress count
	fread(&phoneInfoCompressCount,sizeof(int),1,file);
    
	int left = 0, right = phoneInfoCompressCount - 1;
	NumberInfoCompress infoMiddle;
	//begin binary search
	while(left <= right){
		int middle = (left + right) / 2;
		//put the write point in the  middle phoneInfoCompress
		fseek(file,sizeof(int) + middle * sizeof(NumberInfoCompress),SEEK_SET);
		fread(&infoMiddle,sizeof(NumberInfoCompress),1,file);
        
		if(number < infoMiddle.getBegin()){
			right = middle - 1;
		}else if(number > (infoMiddle.getBegin() + infoMiddle.getSkip())){
			left = middle + 1;
		}else{// find the result
			return DoFindResultThing(file, phoneInfoCompressCount, infoMiddle);
		}
	}
	fclose(file);
	return NULL;
}

bool NumberInfoAction::ChangeTxtToBinary(const char* inFileName,const char* outFileName){
	FILE* inFile = 0;
	inFile = fopen(inFileName,"rb");
	if(inFile == 0)
		return false;
	FILE* outFile = 0;
	outFile = fopen(outFileName,"wb");
	if(outFile == 0)
		return false;
    
	int phoneInfoCompressCount = 0;
	//firstly, write the count of total phoneInfoCompress.
	fwrite(&phoneInfoCompressCount,sizeof(int),1,outFile);
    
	//secondly, write all the records
	WriteRecords(inFile, phoneInfoCompressCount, outFile);
    
	//thirdly, rewrite the phoneInfoCompressCount.
	fseek(outFile,0,SEEK_SET);
	fwrite(&phoneInfoCompressCount,sizeof(int),1,outFile);
    
	//last, write all the cities
	WriteCities(outFile);
    
	fclose(inFile);
	fclose(outFile);
	return true;
}