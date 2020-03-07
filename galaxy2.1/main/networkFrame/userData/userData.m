//
//  userData.m
//  galaxy
//
//  Created by 赵碚 on 15/8/24.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import "userData.h"
//#import "SFHFKeychainUtils.h"

@implementation userData

static userData * userInfo;

//单例对象
+ (userData *)shareUserData {
    if(userInfo == nil) {
        userInfo = [[userData alloc]init];
    }
    return userInfo;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSData* userInfoData = [userDefaults objectForKey:@"galaxy_userInfo"];
        userData* userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
        if (userInfo!=nil) {
            self.logName       = userInfo.logName;
            self.userDspName   = userInfo.userDspName;
            self.password      = userInfo.password;
            self.token         = userInfo.token;
            self.userId        = userInfo.userId;
            self.isFirstLogin  = userInfo.isFirstLogin;
            self.isRegister    = userInfo.isRegister;
            self.language      = userInfo.language;
            self.photoGraph    = userInfo.photoGraph;
            self.experience    = userInfo.experience;
            self.userRole      = userInfo.userRole;
            self.messageCenter = userInfo.messageCenter;
            self.shareUrl      = userInfo.shareUrl;
            self.shareTitle    = userInfo.shareTitle;
            self.shareContent  = userInfo.shareContent;
            self.cacheTimeArr  = userInfo.cacheTimeArr;
            self.hasReportArr  = userInfo.hasReportArr;
            self.isPasswordComplexity = userInfo.isPasswordComplexity;
            self.passwordMaxLength    = userInfo.passwordMaxLength;
            self.passwordMinLength    = userInfo.passwordMinLength;
            self.isOnlinePay = userInfo.isOnlinePay;
            self.CorpActTyp = userInfo.CorpActTyp;
            self.companyLogo = userInfo.companyLogo;
            self.company = userInfo.company;
            self.companyId = userInfo.companyId;
            self.department = userInfo.department;
            self.cacheItems = userInfo.cacheItems;
            self.multCompanyId = @"0";
            
            self.multiCyPayment = userInfo.multiCyPayment;
            self.isOpenChanPay = userInfo.isOpenChanPay;

            
            self.str_RelateTravelForm = userInfo.str_RelateTravelForm;
            self.bool_IsUrge = userInfo.bool_IsUrge;
            self.record_selfDrive = userInfo.record_selfDrive;
            self.menuHide = userInfo.menuHide;
            if (userInfo.isFirstLogin == nil)//当为空的时候，才成yes，其他状况全为NO
            {
                self.isFirstLogin  = FirstLogin_yes;
            }
            self.isRememberPwd = userInfo.isRememberPwd;
            if (userInfo.isRememberPwd == nil) {
                self.isRememberPwd = Remember;
            }
            self.curVer        = userInfo.curVer;
            self.curVerUrl     = userInfo.curVerUrl;
            self.Nofication = userInfo.Nofication;
            self.RefreshStr = userInfo.RefreshStr;
            self.mySystemStr= userInfo.mySystemStr;
            self.work_waitNum= userInfo.work_waitNum;
            
            self.arr_XBOpenFlowcode= userInfo.arr_XBOpenFlowcode;
            self.dict_XBAllFlowInfo=userInfo.dict_XBAllFlowInfo;
            self.arr_XBFlowcode = userInfo.arr_XBFlowcode;
            self.arr_XBCode = userInfo.arr_XBCode;
            self.arr_ReimMeumArray=userInfo.arr_ReimMeumArray;
            self.arr_WorkMeumArray=userInfo.arr_WorkMeumArray;
            self.arr_AppMeumArray=userInfo.arr_AppMeumArray;

            self.AddComeInType=userInfo.AddComeInType;
            //推送设定
            
            self.SystemUserId = userInfo.SystemUserId;
            self.SystemToken = userInfo.SystemToken;
            self.SystemType = userInfo.SystemType;
            self.bool_AgentHasApprove = userInfo.bool_AgentHasApprove;
            self.checkExpiryDic = userInfo.checkExpiryDic;
            
            
            
            NSString * isPush = [userDefaults objectForKey:@"logistics_isPush"];
            self.isPush = isPush == nil ? @"0" : isPush;
        }
        
        self.cache01 = [userDefaults objectForKey:@"01"];
        self.cache02 = [userDefaults objectForKey:@"02"];
        self.cache03 = [[NSUserDefaults standardUserDefaults] objectForKey:@"03"];
        self.cache04 = [userDefaults objectForKey:@"04"];
        self.cache05 = [userDefaults objectForKey:@"05"];
        self.cache06 = [userDefaults objectForKey:@"06"];
        self.cache07 = [userDefaults objectForKey:@"07"];
        
        self.local01 = [userDefaults objectForKey:@"local01"];
        self.local02 = [userDefaults objectForKey:@"local02"];
        self.local03 = [userDefaults objectForKey:@"local03"];
        self.local04 = [userDefaults objectForKey:@"local04"];
        self.local05 = [userDefaults objectForKey:@"local05"];
        self.local06 = [userDefaults objectForKey:@"local06"];
        self.local07 = [userDefaults objectForKey:@"local07"];
        
        self.localFile01 = [userDefaults objectForKey:@"localFile01"];
        self.localFile02 = [userDefaults objectForKey:@"localFile02"];
        
        NSData *data=[NSData dataWithContentsOfFile:[PATH_OF_CACHE stringByAppendingPathComponent:@"localFile03"] options:0 error:NULL];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *data2dic = [unarchiver decodeObjectForKey:@"localFile03"];
        [unarchiver finishDecoding];
        //        NSLog(@"%@",data2dic);
        self.localFile03 = data2dic;
        
        self.localFile04 = [userDefaults objectForKey:@"localFile04"];
        self.localFile05 = [userDefaults objectForKey:@"localFile05"];
        self.localFile06 = [userDefaults objectForKey:@"localFile06"];
        self.localFile07 = [userDefaults objectForKey:@"localFile07"];


    }
    return self;
}

-(void) loadLocal{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    self.cache01 = [userDefaults objectForKey:@"01"];
    self.cache02 = [userDefaults objectForKey:@"02"];
    self.cache03 = [[NSUserDefaults standardUserDefaults] objectForKey:@"03"];
    self.cache04 = [userDefaults objectForKey:@"04"];
    self.cache05 = [userDefaults objectForKey:@"05"];
    self.cache06 = [userDefaults objectForKey:@"06"];
    self.cache07 = [userDefaults objectForKey:@"07"];
    
    self.local01 = [userDefaults objectForKey:@"local01"];
    self.local02 = [userDefaults objectForKey:@"local02"];
    self.local03 = [userDefaults objectForKey:@"local03"];
    self.local04 = [userDefaults objectForKey:@"local04"];
    self.local05 = [userDefaults objectForKey:@"local05"];
    self.local06 = [userDefaults objectForKey:@"local06"];
    self.local07 = [userDefaults objectForKey:@"local07"];
    
    self.localFile01 = [userDefaults objectForKey:@"localFile01"];
    self.localFile02 = [userDefaults objectForKey:@"localFile02"];
    
    NSData *data=[NSData dataWithContentsOfFile:[PATH_OF_CACHE stringByAppendingPathComponent:@"localFile03"] options:0 error:NULL];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSDictionary *data2dic = [unarchiver decodeObjectForKey:@"localFile03"];
    [unarchiver finishDecoding];
    //        NSLog(@"%@",data2dic);
    self.localFile03 = data2dic;
    
    self.localFile04 = [userDefaults objectForKey:@"localFile04"];
    self.localFile05 = [userDefaults objectForKey:@"localFile05"];
    self.localFile06 = [userDefaults objectForKey:@"localFile06"];
    self.localFile07 = [userDefaults objectForKey:@"localFile07"];
    
    
    userInfo.cache01 = [userDefaults objectForKey:@"01"];
    userInfo.cache02 = [userDefaults objectForKey:@"02"];
    userInfo.cache03 = [[NSUserDefaults standardUserDefaults] objectForKey:@"03"];
    userInfo.cache04 = [userDefaults objectForKey:@"04"];
    userInfo.cache05 = [userDefaults objectForKey:@"05"];
    userInfo.cache06 = [userDefaults objectForKey:@"06"];
    userInfo.cache07 = [userDefaults objectForKey:@"07"];
    
    userInfo.local01 = [userDefaults objectForKey:@"local01"];
    userInfo.local02 = [userDefaults objectForKey:@"local02"];
    userInfo.local03 = [userDefaults objectForKey:@"local03"];
    userInfo.local04 = [userDefaults objectForKey:@"local04"];
    userInfo.local05 = [userDefaults objectForKey:@"local05"];
    userInfo.local06 = [userDefaults objectForKey:@"local06"];
    userInfo.local07 = [userDefaults objectForKey:@"local07"];
    
    userInfo.localFile01 = [userDefaults objectForKey:@"localFile01"];
    userInfo.localFile02 = [userDefaults objectForKey:@"localFile02"];
    userInfo.localFile03 = data2dic;
    
    userInfo.localFile04 = [userDefaults objectForKey:@"localFile04"];
    userInfo.localFile05 = [userDefaults objectForKey:@"localFile05"];
    userInfo.localFile06 = [userDefaults objectForKey:@"localFile06"];
    userInfo.localFile07 = [userDefaults objectForKey:@"localFile07"];
}

-(void)storeUserInfo{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData* userInfoData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userDefaults setObject:userInfoData forKey:@"galaxy_userInfo"];
    userInfo = self;
    [userDefaults synchronize];
}

+(void)savelocalFile:(NSDictionary *)dic type:(int)number
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userInfo.local01 forKey:@"local01"];
    [userDefaults setObject:userInfo.local02 forKey:@"local02"];
    [userDefaults setObject:userInfo.local03 forKey:@"local03"];
    [userDefaults setObject:userInfo.local04 forKey:@"local04"];
    [userDefaults setObject:userInfo.local05 forKey:@"local05"];
    [userDefaults setObject:userInfo.local06 forKey:@"local06"];
    
    [userDefaults setObject:userInfo.cache01 forKey:@"01"];
    [userDefaults setObject:userInfo.cache02 forKey:@"02"];
    [userDefaults setObject:userInfo.cache03 forKey:@"03"];
    [userDefaults setObject:userInfo.cache04 forKey:@"04"];
    [userDefaults setObject:userInfo.cache05 forKey:@"05"];
    [userDefaults setObject:userInfo.cache06 forKey:@"06"];
    switch (number) {
        case 3:
            userInfo.localFile03 = dic;
            if (dic) {
                NSString *FileName=[PATH_OF_CACHE stringByAppendingPathComponent:@"localFile03"];
                
                NSMutableData *data = [[NSMutableData alloc] init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                [archiver encodeObject:dic forKey:@"localFile03"];
                [archiver finishEncoding];
                [data writeToFile:FileName atomically:YES];
            }
            break;
    }
    [userDefaults synchronize];
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_logName       forKey:@"loginName"];
    [aCoder encodeObject:_userDspName   forKey:@"userDspName"];
    [aCoder encodeObject:_password      forKey:@"password"];
    [aCoder encodeObject:_companyLogo   forKey:@"companyLogo"];
    [aCoder encodeObject:_company       forKey:@"company"];
    [aCoder encodeObject:_companyId     forKey:@"companyId"];
    [aCoder encodeObject:_department    forKey:@"department"];
    [aCoder encodeObject:_cacheItems    forKey:@"cacheItems"];
    [aCoder encodeObject:_token         forKey:@"token"];
    [aCoder encodeObject:_userId        forKey:@"userId"];
    [aCoder encodeObject:_machineCode   forKey:@"machineCode"];
    [aCoder encodeObject:_isRegister    forKey:@"isRegister"];
    [aCoder encodeObject:_isFirstLogin  forKey:@"isFirstLogin"];
    [aCoder encodeObject:_isRememberPwd forKey:@"isRememberPwd"];
    [aCoder encodeObject:_curVer        forKey:@"curVer"];
    [aCoder encodeObject:_curVerUrl     forKey:@"curVerUrl"];
    [aCoder encodeObject:_language      forKey:@"language"];
    [aCoder encodeObject:_photoGraph    forKey:@"photoGraph"];
    [aCoder encodeObject:_experience    forKey:@"experience"];
    [aCoder encodeObject:_messageCenter forKey:@"messageCenter"];
    [aCoder encodeObject:_shareUrl      forKey:@"shareUrl"];
    [aCoder encodeObject:_shareTitle    forKey:@"shareTitle"];
    [aCoder encodeObject:_shareContent  forKey:@"shareContent"];
    [aCoder encodeObject:_isPasswordComplexity forKey:@"isPasswordComplexity"];
    [aCoder encodeObject:_passwordMaxLength    forKey:@"passwordMaxLength"];
    [aCoder encodeObject:_passwordMinLength    forKey:@"passwordMinLength"];
    [aCoder encodeObject:_RefreshStr     forKey:@"RefreshStr"];
    [aCoder encodeObject:_mySystemStr    forKey:@"mySystemStr"];
    [aCoder encodeObject:_work_waitNum   forKey:@"work_waitNum"];
    
    [aCoder encodeObject:_checkExpiryDic forKey:@"checkExpiryDic"];
    [aCoder encodeObject:_AddComeInType  forKey:@"AddComeInType"];
    [aCoder encodeObject:_isOnlinePay    forKey:@"isOnlinePay"];
    [aCoder encodeObject:_CorpActTyp     forKey:@"CorpActTyp"];
    [aCoder encodeObject:_str_RelateTravelForm forKey:@"RelateTravelForm"];
    [aCoder encodeObject:_record_selfDrive forKey:@"SelfDrive"];
    
    [aCoder encodeObject:_multiCyPayment    forKey:@"multiCyPayment"];
    [aCoder encodeObject:_isOpenChanPay    forKey:@"isOpenChanPay"];

    [aCoder encodeObject:_userRole forKey:@"userRole"];
    [aCoder encodeObject:_menuHide forKey:@"menuHide"];
    [aCoder encodeObject:_arr_ReimMeumArray forKey:@"arrReimMeumArray"];
    [aCoder encodeObject:_arr_WorkMeumArray forKey:@"arrWorkMeumArray"];
    [aCoder encodeObject:_arr_XBOpenFlowcode forKey:@"arrXBOpenFlowcode"];
    [aCoder encodeObject:_dict_XBAllFlowInfo forKey:@"dictXBAllFlowInfo"];
    [aCoder encodeObject:_arr_XBFlowcode forKey:@"arrXBFlowcode"];
    [aCoder encodeObject:_arr_XBCode forKey:@"arrXBCode"];
    [aCoder encodeObject:_arr_AppMeumArray forKey:@"arrAppMeumArray"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.logName = [aDecoder decodeObjectForKey:@"loginName"];
        self.userDspName   = [aDecoder decodeObjectForKey:@"userDspName"];
        self.password      = [aDecoder decodeObjectForKey:@"password"];
        self.company       = [aDecoder decodeObjectForKey:@"company"];
        self.companyId     = [aDecoder decodeObjectForKey:@"companyId"];
        self.department    = [aDecoder decodeObjectForKey:@"department"];
        self.cacheItems    = [aDecoder decodeObjectForKey:@"cacheItems"];
        self.token         = [aDecoder decodeObjectForKey:@"token"];
        self.userId        = [aDecoder decodeObjectForKey:@"userId"];
        self.machineCode   = [aDecoder decodeObjectForKey:@"machineCode"];
        self.isRegister    = [aDecoder decodeObjectForKey:@"isRegister"];
        self.isFirstLogin  = [aDecoder decodeObjectForKey:@"isFirstLogin"];
        self.isRememberPwd = [aDecoder decodeObjectForKey:@"isRememberPwd"];
        self.curVer        = [aDecoder decodeObjectForKey:@"curVer"];
        self.curVerUrl     = [aDecoder decodeObjectForKey:@"curVerUrl"];
        self.language      = [aDecoder decodeObjectForKey:@"language"];
        self.photoGraph    = [aDecoder decodeObjectForKey:@"photoGraph"];
        self.experience    = [aDecoder decodeObjectForKey:@"experience"];
        self.messageCenter = [aDecoder decodeObjectForKey:@"messageCenter"];
        self.shareUrl      = [aDecoder decodeObjectForKey:@"shareUrl"];
        self.shareTitle    = [aDecoder decodeObjectForKey:@"shareTitle"];
        self.shareContent  = [aDecoder decodeObjectForKey:@"shareContent"];
        self.isPasswordComplexity = [aDecoder decodeObjectForKey:@"isPasswordComplexity"];
        self.passwordMaxLength    = [aDecoder decodeObjectForKey:@"passwordMaxLength"];
        self.passwordMinLength    = [aDecoder decodeObjectForKey:@"passwordMinLength"];
        self.RefreshStr           = [aDecoder decodeObjectForKey:@"RefreshStr"];
        self.mySystemStr          = [aDecoder decodeObjectForKey:@"mySystemStr"];
        self.work_waitNum          = [aDecoder decodeObjectForKey:@"work_waitNum"];
        self.checkExpiryDic       = [aDecoder decodeObjectForKey:@"checkExpiryDic"];
        self.AddComeInType       = [aDecoder decodeObjectForKey:@"AddComeInType"];
        self.isOnlinePay           = [aDecoder decodeObjectForKey:@"isOnlinePay"];
        self.CorpActTyp           = [aDecoder decodeObjectForKey:@"CorpActTyp"];
        self.companyLogo = [aDecoder decodeObjectForKey:@"companyLogo"];
        self.str_RelateTravelForm = [aDecoder decodeObjectForKey:@"RelateTravelForm"];
        self.record_selfDrive = [aDecoder decodeObjectForKey:@"SelfDrive"];
        
        self.multiCyPayment           = [aDecoder decodeObjectForKey:@"multiCyPayment"];
        self.isOpenChanPay           = [aDecoder decodeObjectForKey:@"isOpenChanPay"];

        
        self.userRole = [aDecoder decodeObjectForKey:@"userRole"];
        self.menuHide = [aDecoder decodeObjectForKey:@"menuHide"];
        self.arr_ReimMeumArray = [aDecoder decodeObjectForKey:@"arrReimMeumArray"];
        self.arr_WorkMeumArray = [aDecoder decodeObjectForKey:@"arrWorkMeumArray"];
        self.arr_XBOpenFlowcode = [aDecoder decodeObjectForKey:@"arrXBOpenFlowcode"];
        self.dict_XBAllFlowInfo = [aDecoder decodeObjectForKey:@"dictXBAllFlowInfo"];
        self.arr_XBFlowcode = [aDecoder decodeObjectForKey:@"arrXBFlowcode"];
        self.arr_XBCode = [aDecoder decodeObjectForKey:@"arrXBCode"];
        self.arr_AppMeumArray = [aDecoder decodeObjectForKey:@"arrAppMeumArray"];

    }
    return self;
}
- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end
