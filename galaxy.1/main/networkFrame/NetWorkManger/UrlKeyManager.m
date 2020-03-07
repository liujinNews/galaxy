//
//  UrlKeyManager.m
//  galaxy
//
//  Created by hfk on 2019/7/22.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import "UrlKeyManager.h"

NSInteger const Source                = 0;

//MARK:Keys
//(*)为新建应用要改
//高德地图(*)
NSString *const AMapKey                      = Source == 1 ?   @"0422a46493bd51e2090e091222f47c1d":@"b5fdfadb7475d27f6735b596515e9f56";
//友盟(*)
NSString *const UmengKey                     = Source == 1 ? @"5d2bd1274ca3570cc3000d20":@"560b7f0e67e58ef50d0008f5";
//WeChat(*)
NSString *const WeChatKey                    = Source == 1 ? @"wx593c02c59c966c6c":@"wx1b934f59449957b9";
NSString *const WeChatSecret                 = Source == 1 ? @"6a40ec138443195d86348ac48e5cd4b1":@"7423fa412c58dd1448af59eeeab12415";

//QQ
NSString *const QQKey                        = @"1104923243";
NSString *const QQSecret                     = @"kFA0w7kxkud52Ze9";
//Sina
NSString *const SinaKey                      = @"3104871679";
NSString *const SinaSecret                   = @"bc11fedeff3ce3180f3377d779de18a5";
//讯飞
NSString *const IFlyKey                      = @"57189fe3";

//回跳喜报Scheme
NSString *const XB_Schems                    = @"Galaxy";
//喜报纳税人识别号
NSString *const XB_EinvMerchantId            = @"9131010407479013XC";

//MARK:Urls
NSString *const XB_FormH5New                 = @"/home/form/";
NSString *const XB_FormH5Has                 = @"/approval/myapplication/";
NSString *const XB_InvoiceH5                 = @"/home/note/InvoicePhoto";
NSString *const XB_InvoiceHead               = @"/document/Share/share.html";
NSString *const XB_ImportStaff               = @"/Document/Instructions/importstaff.html";
NSString *const XB_JoinByCId                 = @"/Document/Instructions/joinenterprise.html";
NSString *const XB_IFPIns                    = @"/document/Fapiao/personal.html";
NSString *const XB_GuideMemberAdd            = @"/Document/Instructions/members.html";
NSString *const XB_GuidePowerSet             = @"/Document/Instructions/employeeperm.html";
NSString *const XB_GuideProcessSet           = @"/Document/Instructions/approvalprocess.html";
NSString *const XB_GuideFormSet              = @"/Document/Instructions/formsettings.html";
NSString *const XB_GuideBudgetSet            = @"/Document/Instructions/budget.html";
NSString *const XB_GuideStandardSet          = @"/Document/Instructions/hotelstandards.html";
NSString *const XB_GuideBoss                 = @"/Document/GettingStarted/Boss.html";
NSString *const XB_GuideFinancial            = @"/Document/GettingStarted/financial.html";
NSString *const XB_GuideEmployee             = @"/Document/GettingStarted/employees.html";
NSString *const XB_BudgetSet                 = @"/Document/Instructions/budgetsetting.html";
NSString *const XB_CityLevelSet              = @"/Document/Instructions/citylevel.html";
NSString *const XB_ApprovalSet               = @"/Document/Instructions/approvalmanagement.html";
NSString *const XB_StandardSet               = @"/Document/Instructions/standardsset.html";
NSString *const XB_FlowChart                 = @"/#/process/";
NSString *const XB_UploadError               = @"logexception/error";
NSString *const XB_Login                     = @"account/loginV2";
NSString *const XB_SettingInfo               = @"account/GetLoginInfos";
NSString *const XB_LoginByCid                = @"account/LoginByCorpCodeV2";
NSString *const XB_JoinCorp                  = @"account/Join";
NSString *const XB_UptCorpInfo               = @"company/UpdateCorpNameAndContact";
NSString *const XB_CreateCorp                = @"account/CreateCorp";
NSString *const XB_ExperienceCode            = @"account/GetExperienceCode";
NSString *const XB_VerifyExperience          = @"account/Experience";
NSString *const XB_SwitchCorp                = @"account/ChangeCompanyV2";
NSString *const XB_PlatformsList             = @"expuser/GetExtPlatforms";
NSString *const XB_CheckUpt                  = @"account/checkver_v2";
NSString *const XB_PawRule                   = @"account/getpwdsetting";
NSString *const XB_FindPawCode               = @"account/getfindpwdcode";
NSString *const XB_FindPaw                   = @"account/findpassword";
NSString *const XB_RegistCode                = @"account/getregcode";
NSString *const XB_Regist                    = @"account/register";
NSString *const XB_FormState                 = @"task/gettaskformsg";
NSString *const XB_DeletAllMsg               = @"MsgHist/DeleteAllV2";
NSString *const XB_ReimSer                   = @"termsser/get";
NSString *const XB_UptUserName               = @"user/updateuserprofile";
NSString *const XB_UptUserPhoto              = @"user/updatephotoforios";
NSString *const XB_MobileHide                = @"user/updatemobilehide";
NSString *const XB_PersonalInfo              = @"user/getuserinfo";
NSString *const XB_DeleteSign                = @"user/DeleteSign";
NSString *const XB_UptCredential             = @"user/updatecredential";
NSString *const XB_MatchBankNo               = @"user/MatchingBankNo";
NSString *const XB_PayBankNo                 = @"user/GetXbxPayBankNo";
NSString *const XB_UptBankInfo               = @"user/updatebankaccountV2";
NSString *const XB_UptPhoneVerifyCode        = @"user/getverifycode";
NSString *const XB_UptMobile                 = @"user/updatemobile";
NSString *const XB_UptEmail                  = @"user/updateemail";
NSString *const XB_ChangePaw                 = @"user/changepassword";
NSString *const XB_ChangeLanguage            = @"user/changelanguage";
NSString *const XB_BatchImportDidi           = @"expuser/ImportBatchDriveCar";
NSString *const XB_FPInvoiceScan             = @"GlorityOcr/Scan";
NSString *const XB_CtripNoImport             = @"Ctrip/GetOrders";
NSString *const XB_CtripImport               = @"Ctrip/GetImportedOrders";
NSString *const XB_ProjsByCostcenter         = @"costcenter/GetProjsByCostcenter";
NSString *const XB_BatchImportCtrip          = @"expuser/ImportXCOrders";


@implementation UrlKeyManager

+ (NSString *)getFormH5URL:(NSString *const) path{

    return [[NSObject formH5BaseURLStr] stringByAppendingString:path];
}
+ (NSString *)getHelpURL:(NSString *const) path{

    return [[NSObject helpBaseURLStr] stringByAppendingString:path];
}

@end
