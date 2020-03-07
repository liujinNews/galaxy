//
//  UrlKeyManager.h
//  galaxy
//
//  Created by hfk on 2019/7/22.
//  Copyright © 2019 赵碚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSInteger const Source;
//MARK:Keys
//(*)为新建应用要改
//高德地图(*)
extern NSString *const AMapKey;
//友盟(*)
extern NSString *const UmengKey;
//WeChat(*)
extern NSString *const WeChatKey;
extern NSString *const WeChatSecret;
//QQ
extern NSString *const QQKey;
extern NSString *const QQSecret;
//Sina
extern NSString *const SinaKey;
extern NSString *const SinaSecret;
//讯飞
extern NSString *const IFlyKey;
//回跳喜报Scheme
extern NSString *const XB_Schems;
//喜报纳税人识别号
extern NSString *const XB_EinvMerchantId;

//MARK:Urls
extern NSString *const XB_FormH5New;//H5表单新建
extern NSString *const XB_FormH5Has;//H5表单查看
extern NSString *const XB_InvoiceH5;//H5发票查验
extern NSString *const XB_InvoiceHead;//发票抬头
extern NSString *const XB_ImportStaff;//批量导入成员
extern NSString *const XB_JoinByCId;//填写企业号加入
extern NSString *const XB_IFPIns;//电子发票使用说明
extern NSString *const XB_GuideMemberAdd;//如何添加成员
extern NSString *const XB_GuidePowerSet;//如何设置员工权限
extern NSString *const XB_GuideProcessSet;//如何设置审批流程
extern NSString *const XB_GuideFormSet;//如何设置自定义表单
extern NSString *const XB_GuideBudgetSet;//如何设置预算
extern NSString *const XB_GuideStandardSet;//如何设置住宿标准
extern NSString *const XB_GuideBoss;//我是老板
extern NSString *const XB_GuideFinancial;//我是财务
extern NSString *const XB_GuideEmployee;//我是员工
extern NSString *const XB_BudgetSet;//预算管理
extern NSString *const XB_CityLevelSet;//城市级别
extern NSString *const XB_ApprovalSet;//审批管理
extern NSString *const XB_StandardSet;//报销标准
extern NSString *const XB_FlowChart;//流程图
extern NSString *const XB_UploadError;//发送崩溃日志
extern NSString *const XB_Login;//用户登陆
extern NSString *const XB_SettingInfo;//获取登陆后设置信息
extern NSString *const XB_LoginByCid;//企业号登陆
extern NSString *const XB_JoinCorp;//加入已有企业
extern NSString *const XB_UptCorpInfo;//完善公司信息
extern NSString *const XB_CreateCorp;//创建新公司
extern NSString *const XB_ExperienceCode;//获取体验验证码
extern NSString *const XB_VerifyExperience;//验证体验
extern NSString *const XB_SwitchCorp;//切换公司
extern NSString *const XB_PlatformsList;//获取第三方平台列表
extern NSString *const XB_CheckUpt;//检查是否需要更新
extern NSString *const XB_PawRule;//密码规则
extern NSString *const XB_FindPawCode;//找回密码验证码
extern NSString *const XB_FindPaw;//找回密码
extern NSString *const XB_RegistCode;//注册验证码
extern NSString *const XB_Regist;//注册
extern NSString *const XB_FormState;//获取表单当前状态
extern NSString *const XB_DeletAllMsg;//清空消费记录
extern NSString *const XB_ReimSer;//报销协议
extern NSString *const XB_UptUserName;//更新用户姓名性别
extern NSString *const XB_UptUserPhoto;//更新用户头像
extern NSString *const XB_MobileHide;//是否隐藏号码
extern NSString *const XB_PersonalInfo;//个人信息
extern NSString *const XB_DeleteSign;//删除签名
extern NSString *const XB_UptCredential;//更新证件信息
extern NSString *const XB_MatchBankNo;//核对银行卡卡号
extern NSString *const XB_PayBankNo;//喜报付款人银行卡号
extern NSString *const XB_UptBankInfo;//更新用户银行信息
extern NSString *const XB_UptPhoneVerifyCode;//更新手机邮箱验证码
extern NSString *const XB_UptMobile;//更新手机号
extern NSString *const XB_UptEmail;//更新邮箱
extern NSString *const XB_ChangePaw;//修改密码
extern NSString *const XB_ChangeLanguage;//语言设置
extern NSString *const XB_BatchImportDidi;//批量导入滴滴订单
extern NSString *const XB_FPInvoiceScan;//发票拍照
extern NSString *const XB_CtripNoImport;//携程未导入
extern NSString *const XB_CtripImport;//携程已导入
extern NSString *const XB_ProjsByCostcenter;//根据costcenter请求项目
extern NSString *const XB_BatchImportCtrip;//批量导入携程订单


@interface UrlKeyManager : NSObject
//H5链接
+ (NSString *)getFormH5URL:(NSString *const) path;
//帮助链接
+ (NSString *)getHelpURL:(NSString *const) path;


@end

NS_ASSUME_NONNULL_END
