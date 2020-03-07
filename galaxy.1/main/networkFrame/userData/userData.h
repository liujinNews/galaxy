//
//  userData.h
//  galaxy
//
//  Created by 赵碚 on 15/8/24.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#define Remember       @"YES"
#define unRemember     @"NO"
#define Login_yes      @"YES"
#define Login_no       @"NO"
#define FirstLogin_yes @"YES"
#define FirstLogin_no  @"NO"

#import <Foundation/Foundation.h>
#import "Record.h"

@interface userData : NSObject

@property (nonatomic,copy)NSString * logName;    //登录名，手机号或者邮箱号
@property (nonatomic,copy)NSString * password;   //密码
@property (nonatomic,copy)NSString * token;      //
@property (nonatomic,copy)NSString * machineCode;//机器码
@property (nonatomic,copy)NSString * userDspName;       //用户名，公司名称或个人名称
@property (nonatomic,copy)NSString * userId;     //用户id
@property (nonatomic,copy)NSString * sex;        //性别
@property (nonatomic,copy)NSString * phoneNumber;//手机号
@property (nonatomic,copy)NSString * email;      //邮箱
@property (nonatomic,copy)NSString * position;   //职位
@property (nonatomic,copy)NSString * bankCard;   //银行卡
@property (nonatomic,copy)NSString * card;       //身份证
@property (nonatomic,copy)NSString * company;    //公司
@property (nonatomic,copy)NSString * companyId;    //公司ID
@property (nonatomic,copy)NSString * department;    //部门
@property (nonatomic,strong)NSMutableDictionary * cacheItems;//缓存是否需要请求

@property (nonatomic,copy)NSString * multCompanyId;    //多公司消息ID

@property (nonatomic,copy)NSString * multiCyPayment;    //显示付款金额方式(1是显示付款金额 01是显示本位币币种)

@property (nonatomic,copy)NSString * isOpenChanPay;    //是否开启银企直联（1是，0否）



@property (nonatomic,copy)NSString * language;   //语言
@property (nonatomic,copy)NSString * photoGraph; //头像
@property (nonatomic,copy)NSString * experience;  //体验
@property (nonatomic,copy)NSString * groupid;  //分组ID
@property (nonatomic,copy)NSString * groupname;  //公司名称
@property (nonatomic,copy)NSString * companyLogo;//公司logo
@property (nonatomic,strong)NSMutableArray * userRole;   //角色1、所有、2.系统管理员、3.流程、4.财务、5.总经理、6.财务总经理、7.出纳、8.行政管理员

@property (nonatomic,assign) NSInteger source;//来源

@property (nonatomic, strong) NSString *isSystem;   //是否管理员
@property (nonatomic, strong) NSString *menuHide;   //权限
@property (nonatomic,copy)NSString * messageCenter;//消息通知
@property(nonatomic,copy)NSString * shareTitle;    //分享标题头
@property(nonatomic,copy)NSString * shareContent;  //分享内容
@property(nonatomic,copy)NSString * shareUrl;      //分享地址

//2.6版本修改内容
@property(nonatomic,strong)NSMutableArray * cacheTimeArr;//缓存时间
@property(nonatomic,strong)NSMutableArray * hasReportArr;//报表权限
@property(nonatomic,copy)NSString *gender;

@property (copy, nonatomic) NSString * isRegister;     //是否注册状态
@property (copy, nonatomic) NSString * isRememberPwd;  //是否记住密码
@property (copy, nonatomic) NSString * isFirstLogin;   //是否是第一次登录
@property (copy, nonatomic) NSString * canGetCheckcode;//是否正在获取checkcode

@property (copy, nonatomic) NSString * curVer;   //服务器返回版本号
@property (copy, nonatomic) NSString * curVerUrl;//服务器返回下载地址
@property (copy, nonatomic) NSString   * pushToken;//推送token
@property (copy, nonatomic) NSString * isPush;   //是否推送,0不推，1推

@property (copy, nonatomic) NSString * result;   //权限 1 系统管理员

@property (nonatomic, strong) NSString *coCode;//真格验证
//公司开启流程
@property (nonatomic, strong) NSMutableArray *arr_XBOpenFlowcode;
//公司流程信息字典
@property (nonatomic, strong) NSMutableDictionary *dict_XBAllFlowInfo;
//个人权限开启流程显示
@property (nonatomic, strong) NSMutableArray *arr_XBFlowcode;
//应用
@property (nonatomic, strong) NSMutableArray *arr_XBCode;


@property (copy, nonatomic) NSString * isPasswordComplexity;//密码规则
@property (copy, nonatomic) NSString * passwordMaxLength;//最大密码长度
@property (copy, nonatomic) NSString * passwordMinLength;//最小密码长度

@property (nonatomic, copy) NSString * cache01;//费用类别
@property (nonatomic, copy) NSString * cache02;//成本中心
@property (nonatomic, copy) NSString * cache03;//城市
@property (nonatomic, copy) NSString * cache04;//币种
@property (nonatomic, copy) NSString * cache05;//通讯录
@property (nonatomic, copy) NSString * cache06;//关于我们
@property (nonatomic, copy) NSString * cache07;//报销协议

//本地的版本
@property (nonatomic, copy) NSString * local01;//费用类别
@property (nonatomic, copy) NSString * local02;//成本中心
@property (nonatomic, copy) NSString * local03;//城市
@property (nonatomic, copy) NSString * local04;//币种
@property (nonatomic, copy) NSString * local05;//通讯录
@property (nonatomic, copy) NSString * local06;//关于我们
@property (nonatomic, copy) NSString * local07;//报销协议

@property (nonatomic, copy) NSDictionary * localFile01;//费用类别
@property (nonatomic, copy) NSDictionary * localFile02;//成本中心
@property (nonatomic, copy) NSDictionary * localFile03;//城市
@property (nonatomic, copy) NSDictionary * localFile04;//币种
@property (nonatomic, copy) NSDictionary * localFile05;//通讯录
@property (nonatomic, copy) NSDictionary * localFile06;//关于我们
@property (nonatomic, copy) NSDictionary * localFile07;//报销协议

@property (nonatomic, assign) NSInteger PeoplePage;//修改联系人选择部门用

@property (nonatomic, assign) int SystemType;//是否代理进入 0 不是 1 是
@property (nonatomic, assign) BOOL bool_AgentHasApprove;//代理进入是否有审批权限 no 不是 yes 是

@property (nonatomic, copy)NSString * SystemToken;      //代理Token
@property (nonatomic, copy)NSString * SystemAccount;      //代理账号
@property (nonatomic, copy)NSString * SystemphotoGraph; //代理头像
@property (nonatomic, copy)NSString * SystemUserId;     //代理用户id
@property (nonatomic, copy)NSString * SystemRequestor;     //代理用户名称
@property (nonatomic, copy)NSString * SystemRequestorDept;     //代理用户部门

@property (nonatomic, strong)NSDictionary *Nofication; //通知
@property (nonatomic, strong)NSString * RefreshStr;//是否刷新我的界面
@property (nonatomic, strong)NSString * mySystemStr;//


@property (nonatomic,copy)NSString *work_waitNum;  //工作页面待审批数量


@property (nonatomic, strong)NSString *isOnlinePay;//是否在线支付 2.6.8

@property (nonatomic, strong)NSString *CorpActTyp;//企业帐户类型(4:高级类型)

@property (nonatomic, strong)NSDictionary * checkExpiryDic;
/**
 费用菜单数组
 */
@property (nonatomic, strong)NSMutableArray *arr_ReimMeumArray;
/**
 工作菜单数组
 */
@property (nonatomic, strong)NSMutableArray *arr_WorkMeumArray;
/**
 应用菜单数组
 */
@property (nonatomic, strong)NSMutableArray *arr_AppMeumArray;
/**
 是否关联出差申请单
 */
@property (nonatomic, copy)NSString *str_RelateTravelForm;
/**
 是否可以催办
 */
@property (nonatomic, assign)BOOL bool_IsUrge;
/**
 在编辑的费用类别
 */
@property (nonatomic, strong)NSString *AddComeInType;

@property (nonatomic, strong) NSArray *arr_used_people;
@property (nonatomic, strong) NSArray *arr_noused_people;

@property (nonatomic, strong) Record *record_selfDrive;



//单例对象
+(userData *)shareUserData;
-(instancetype)init;
- (void)storeUserInfo;
-(void) loadLocal;
+(void)savelocalFile:(NSDictionary *)dic type:(int)i;



@end



