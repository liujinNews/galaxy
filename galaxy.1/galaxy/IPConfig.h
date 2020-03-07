//
//  IPConfig.h
//  galaxy
//
//  Created by 贺一鸣 on 2018/1/8.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#ifndef IPConfig_h
#define IPConfig_h


#endif /* IPConfig_h */

//MARK: 网络部分
//开发185
#define XBServer_T185        @"http://10.1.2.185:8080/api/"
//开发17   8201
#define XBServer_T17_8201         @"http://10.1.2.17:8201/api/"
//开发17   8082
#define XBServer_T155_8082         @"http://10.1.2.155:8082/api/"
//开发17_8088
#define XBServer_T17_8088         @"http://10.1.2.17:8088/api/"
//开发17_8071
#define XBServer_T17_8071         @"http://10.1.2.17:8071/api/"
//开发T234 8083
#define XBServer_T234        @"http://10.1.2.234:8083/api/"
//开发17   8101
#define XBServer_T17_8101       @"http://10.1.2.17:8101/api/"
//开发194
#define XBServer_T194        @"http://10.1.2.194:8086/api/"
//开发131
#define XBServer_T131        @"http://10.1.2.131:8088/api/"
//开发线54
#define XBServer_T54         @"http://10.1.2.54:8088/api/"
//开发线542
#define XBServer_T542        @"http://10.1.2.54:8023/api/"
//开发线156
#define XBServer_T156        @"http://10.1.2.156:8080/api/"
//开发线157
#define XBServer_T157        @"http://10.1.2.157:7071/api/"
//开发线135
#define XBServer_T135        @"http://10.1.2.135:8081/api/"
//开发线236
#define XBServer_T236        @"http://10.1.2.236:8002/api/"
//喜报H5test
#define XBH5Server_T         @"http://10.1.2.230:3001/#"

//#define XBServer_37          @"http://api37.xibaoxiao.com/api/"

//喜报外网
#define XBServer             @"https://api37.xibaoxiao.com/api/"
//#define XBServer             @"https://xiaoapi.xibaoxiao.com/api/"

//喜报文件传输
#define XBServerFile         @"https://xiaoapi.xibaoxiao.com/api/"
//喜报文件传输测试
#define XBServerFile_T_17_8088      @"http://10.1.2.17:8088/api/"

#define AlipayBack           @"https://dingtalk.xibaoxiao.com/home/form/AlipayInvoice"
//#define AlipayBack           @"http://10.1.2.230:3000/home/form/AlipayInvoice"
//雪球外网
#define XBServer_SB          @"https://api.xueqiufinance.com/api/"
//喜报H5
#define XBH5Server           @"http://139.196.104.114:82"
//雪球H5
#define XBH5Server_SB        @"https://h5.xueqiufinance.com"
//喜报help
#define XBHelpServer         @"https://help.xibaoxiao.com"
//雪球help
#define XBHelpServer_SB      @"https://help.xueqiufinance.com"
//雪球测试
#define XBServer_SB_17_8031     @"http://10.1.2.17:8301/api/"

////////***************************************接口*************/

//**********设置***********/

//保存设置
#define saveMSG   @"msgsubscribe/save"

//消息设置
#define getMSG   @"msgsubscribe/get"

//5.4、意见反馈
#define feedback   @"user/feedback"

//关于我们
#define about   @"user/about"

//分享
#define share   @"user/share"


//常见问题
#define commandProblem  @"faq/get"

//费用类别
#define COSTClasses @"exptyp/getexptyps"

//修改费用类别状态 int Id，int Status （1：启用，0：禁用）
#define updatestatus @"exptyp/updatestatus"

//删除费用类别
#define deleteCostClasses @"exptyp/deleteexptyp"
//新增费用类别
#define ADDCostClasses @"exptyp/insertexptyp"

#define InsertExpTypV2 @"exptyp/InsertExpTypV2"

//修改费用类别
#define UpdateCostClasses @"exptyp/updateexptyp"

#define UpdateExpTypV3 @"exptyp/UpdateExpTypV3"

#define GETEXPTYPESETTING @"exptyp/GetExpTypSetting"
#define SAVEEXPTYPESETTING @"exptyp/SaveExpTypSetting"





//员工借款查询
#define getuserloans @"userloan/getuserloans"

//员工借款记录
#define getuserloanhist @"userloan/getuserloanhist"
//员工借款详细记录
#define GetLoanDetails @"userloan/GetLoanDetails"
//员工还款
#define USERLOANREPAYMENT @"userloan/repayment"
//员工详细还款
#define RepayByDetail @"userloan/RepayByDetail"
//获取我的账单总金额
#define GetMyCostTotalByMonth @"mydist/GetMyCostTotalByMonth"

//获取的借款单据信息
#define GetMyLoanList @"myloan/GetMyLoanList"

//获取获取我的支出
#define GetMyCostByMonth @"mydist/GetMyCostByMonth"

//////////////////////2.0
//采购类型修改
#define UpdatePurchaseType  @"Purchase/UpdatePurchaseType"

//采购类型删除
#define DeletePurchaseType  @"Purchase/DeletePurchaseType"

//采购类型新增
#define InserPurchaseType  @"Purchase/InserPurchaseType"

//获取采购类型列表
#define GetPurchaseTypeList  @"Purchase/GetPurchaseTypeList"


//修改支付方式
#define UpdatePurchasePay  @"Purchase/UpdatePurchasePay"

//支付方式删除
#define DeletePurchasePay  @"Purchase/DeletePurchasePay"

//采购支付方式新增
#define InserPurchasePay  @"Purchase/InserPurchasePay"

//获取支付方式列表
#define GetPurchasePayList  @"Purchase/GetPurchasePayList"

//获取选择新审批步骤列表
#define GetNodesByFlowGuid @"task/GetNodesByFlowGuid"

//获取业务部门列表
#define GetBusDepts @"user/GetBusDepts"




// 更新审批节点
#define UpdateProcNodeId @"task/UpdateProcNodeId"

//成本中心列表
#define getcostcs   @"costcenter/getcostcs"

//获取公司列表
#define GetBranch   @"user/GetBranch"

//新增成本中心
#define insertcostc   @"costcenter/insertcostc"

//修改成本中心
#define updatecostc   @"costcenter/updatecostc"

//删除成本中心
#define deletecostc   @"costcenter/deletecostc"

//币种列表
#define getcurrencies   @"currency/getcurrencies"

//新增币种
#define insertcurrency   @"currency/insertcurrency"

//修改币种
#define updatecurrency   @"currency/updatecurrency"

//删除币种
#define deletecurrency   @"currency/deletecurrency"

//修改本位币
#define SETSTANDARDCUR   @"Currency/SetStdMoney"

//获取币种2.6.1
#define GetCurrencyList   @"currency/GetCurrencyList"


//参数设置
//是否开启币种和汇率请求数据
#define getexpparam      @"expparams/getexpparam"
//修改参数
#define updateexpparam     @"expparams/updateexpparam"

//项目管理
//参数列表
#define getProjs     @"proj/getProjs"
#define getProjsBYUSEID     @"proj/GetProjListByUserId"

//删除参数列表
#define deleteproj    @"proj/deleteproj"
//添加项目
#define insertproj    @"proj/insertproj"
//修改项目
#define updateproj    @"proj/updateproj"

//获取项目类型列表
#define GETPROJTYPELIST @"proj/GetProjTypList"
//保存修改项目类型
#define DEALPROJTYPE @"proj/SaveProjTyp"
//删除项目类型
#define DELEPROJTYPE @"proj/DeleteProjTyp"


//获取是否限制员工住宿标准
#define GetParam      @"HotelStandard/GetParam"
//保存是否限制员工住宿标准
#define SaveParam     @"HotelStandard/SaveParam"
//保存超标准是否能够提交
#define SaveHotelSubmit     @"expparams/Saveexpparam"

//获取员工级别
#define GetUserLevels @"HotelStandard/GetUserLevels"
#define GetUserLevelsV2 @"HotelStandard/GetUserLevelsV2"

#define GetStdAllowanceV2 @"StdAllowance/GetStdAllowanceV2"
#define StdGetAllowanceV2 @"Std/GetStdAllowances"
#define StdGetAllSet @"Std/GetAllSet"

#define GetHotelStandardUserLevel @"Std/GetHotelStandardUserLevel"

#define GetStdSelfDrive @"Std/GetStdSelfDrive"

#define GetStdAllowanceList @"Std/GetStdAllowanceList"

#define GetStd @"Std/GetStd"

//获取员工级别
#define GetUserLevels_V2  @"HotelStandard/GetHotelStandard"
//保存员工级别对应的住宿标准
#define SaveHotelStandard  @"HotelStandard/SaveHotelStandard"



//************我的企业************/
//我的企业
#define getcosummary   @"user/getcosummary"

#define GetMobContacts   @"UserMobComtact/GetMobContacts"

//企业信息
#define getcompany   @"user/getcompany"

//新的企业信息
#define GetCoInfo    @"company/GetCoInfo"

//获取清空测试数据验证码
#define companyGetVerifyCode    @"company/GetVerifyCode"

//清空测试数据
#define ClearTestData    @"company/ClearTestData"

//修改企业信息保存
#define getcompanyput   @"company/put"

//获取所属行业、区域、规模
#define getcompanyget   @"company/get"

//获取
#define UpdateCliamDate @"company/UpdateCliamDate"

//邀请方式
#define invite   @"user/invite"

//企业通讯录
#define getusers   @"user/contacts"
//权限设置
#define EditPower  @"rolembr/getroles"

//删除角色
#define DELETEROLE  @"rolembr/DeleteRole"
//添加角色
#define INSERTROLE  @"rolembr/InsertRole"
//编辑角色
#define UPDATEROLE  @"rolembr/UpdateRole"

//权限成员
#define PowerMember @"rolembr/getrolembrs"
//权限成员
#define PowerMemberNew @"rolembr/GetRoleMbrsList"
//权限成员删除
#define PowerMemberDelete @"rolembr/deleterolembr"
//权限成员添加
#define PowerMemberInsert  @"rolembr/insertrolembr"

//申请审批
#define updateuserisa   @"user/updateisactivated"

//申请拒绝
#define userReject   @"user/Reject"

//职位角色成员
#define getjobtitles   @"jobtitle/getjobtitles"

//新增职位
#define insertjobtitle   @"jobtitle/insertjobtitle"

//修改职位
#define updatejobtitle   @"jobtitle/updatejobtitle"

//删除职位
#define deletejobtitle   @"jobtitle/deletejobtitle"

//员工级别
#define getuserlevels   @"userlevel/getuserlevels"

//新增员工
#define addmbr          @"groupmbr/addmbr"

//修改员工
#define updatembr       @"groupmbr/updatembr"

//删除用户
#define deleteuser      @"user/delete"

//禁用用户
#define upstatus        @"user/updatestatus"

//添加子部门
#define addgroup        @"groupmbr/addgroup"

//修改组织名称
#define renamegroup     @"groupmbr/renamegroup"

//删除组织名称
#define deletegroup     @"groupmbr/deletegroup"

//新增员工级别
#define insertuserlevel   @"userlevel/insertuserlevel"

//修改员工级别
#define updateuserlevel   @"userlevel/updateuserlevel"

//删除员工级别
#define deleteuserlevel   @"userlevel/deleteuserlevel"

//获取员工信息
#define groupgetuser           @"user/getuser"

#define GetUserMobContact           @"user/GetUserMobContact"

//获取员工信息
#define groupgetuser_V2           @"user/getuser_V2"

//获取空白员工信息
#define GetUserModify  @"user/GetUserModify"

//保存企业开票信息
#define SaveCoCard      @"CoCard/SaveCoCard"

//获取企业开票信息
#define GetCoCard      @"CoCard/GetCoCard"

//获取企业开票信息
#define GetCoCardInfo  @"CoCard/CoCard1"
//获取企业开票信息列表
#define GetCoCardList  @"CoCard/GetCoCardList"
//删除企业开票信息
#define DeleteCoCard   @"CoCard/DelCoCard"
//保存企业开票信息
#define SaveNewCoCard      @"CoCard/SaveCoCard1"


//************统计分析************/

// 趋势
#define getmytrend   @"mytrend/getmytrend"

// 分布
#define getmydist   @"mydist/getmydist"

//报销统计
#define analyzesGetinitclaimss     @"statistics/InitClaimsStatisticsList"


//项目费用统计
#define GetMonProjs     @"ProjCostAct/GetMonProjs"

//采购统计
#define GetMonPurs     @"StatisticsWk/GetMonPurs"


//费用统计
#define analyzesGetinitcost        @"statistics/initcoststatistics"

//获取预算统计详情
#define InitBudgetStatisticsRptSecond      @"Statistics/InitBudgetStatisticsRptSecond"

//预算统计
#define analyzesGetinitbudget      @"statistics/InitBudgetStatisticsRpt"

//员工动向App接口
#define analyzesGetemployee       @"statistics/getemployeetrendspie"
//预算统计明细
#define analyDetailGetbudgetdetail     @"statistics/initbudgetstatisticsdetail"
//费用统计明细
#define analyDetailGetcostdetail     @"statistics/getcoststatisticsdetail"
//我的借款
#define analyDetailGetmyloanhist     @"myloan/getmyloanhist"

//获取我的支出（新）
#define GetMyCostByYearAndMonth     @"mydist/GetMyCostByYearAndMonth"


//单据查询
#define analyDocumentSearch  @"task/gettasks"
#define analyDocumentSearch_new  @"Task/GetTaskList"//新接口
#define analyDocumentSearch_V2  @"Task/GetTaskListV2"//新接口
//物品明细统计
#define GetMonItems    @"StatisticsWk/GetMonItems"
//请假明细统计
#define GetLeaves    @"StatisticsWk/GetLeaves"
//获取员工动向统计
#define GetEmpTrendsList    @"Statistics/GetEmpTrendsList"
//根据目标城市获取员工动向统计
#define GetEmpTrendsDetailsList    @"Statistics/GetEmpTrendsDetailsList"
//员工费用明细统计
#define GetRequestMonList    @"RequestCostAct/GetRequestMonList"
//员工费用明细统计（新）
#define GetRequestList    @"RequestCostAct/GetRequestList"

//获取费用统计
#define GetCostStatisticsList     @"Statistics/GetCostStatisticsList"


//Expense Type 维护列表接口 // POST api/ int ParentId（必选） string TypPurp （查询）
#define GetTypPurpAll    @"TypPurp/GetAll"

//Expense Type 新增接口 // POST api/TypPurp/Insert参数：string TypPurp int ParentId
#define GetTypPurpInsert    @"TypPurp/Insert"

//Expense Type 修改接口 // POST api/TypPurp/Update 参数： int Id string TypPurp int ParentId
#define GetTypPurpUpdate    @"TypPurp/Update"

//Expense Type 删除接口 // POST api/TypPurp/Delete 参数： int Id int ParentId
#define GetTypPurpDelete    @"TypPurp/Delete"

//项目费用统计（2.0）
#define GetProjList     @"ProjCostAct/GetProjList"

//************消费记录************/
#define homeRequestCostList          @"expuser/get"//消费记录
#define homeRequestDeleteList        @"expuser/delete"//消费记录删除
#define homeRequestSearchList  @"expuser/search"//筛选记录

//#define taskScanQRCode  @"task/ScanQRCode" //二维码扫描
#define taskScanQRCode  @"task/ScanQRCode_V2" //二维码扫描

//************记一笔************/
#define addRequestImage @"expuser/upload"//记一笔上传图片
#define addNewRequestImage @"expuser/uploader"//记一笔上传图片
#define addRequestAddCostList @"expuser/post"//添加
#define addRequestEditCostList @"expuser/put"//修改
#define CheckInvoiceNo @"expuser/CheckInvoiceNo" //发票验证
#define addJudgeCostCategry   @"expuser/getexpuserfld_v1"//判断成本中心
#define addCostCenterCategrys @"costcenter/getcostcenterbox"//成本中心内容
#define addAddCostCategry     @"exptyp/get"//费用类别
#define expuserGetStdType     @"expuser/GetStdType"
#define GetAddCostNewCategry     @"exptyp/gettyps"//2.4获取费用类别
//#define addGetHousePrice      @"expuser/gethouseprice"//房价信息
#define addGetHousePrice      @"expuser/GetHousePrice_V2"//房价信息
#define GETUserStd            @"expuser/GetUserStd"//ExpUser - 获取用户补贴标准
#define GETPersonalPDF    @"BaiWang/GetInvoicePdf"//获取百望个人电子发票PDF文件
#define GETCompanyPDF      @"BaiWang/GetInvoiceEntPdf"//获取百望企业电子发票PDF文件
#define baiwangAddInv      @"BaiWang/AddInv"
#define BaiWangGetEntoken      @"BaiWang/GetEntoken"
#define BaiWangGetInvoiceList      @"BaiWang/GetInvoiceList"
#define BaiWangGetInvoiceListv2      @"BaiWang/GetInvoiceList_v2"
#define BaiWCloudCheckInv      @"BaiWCloud/CheckInv"
#define BaiWangGetInvoiceDetail      @"BaiWang/GetInvoiceDetail"
#define expuser_GetFormData      @"expuser/GetFormData"
#define expuserGetFormDataByProcIdAndTaskId      @"expuser/GetFormDataByProcIdAndTaskId"

#define BW_GetInvoiceDetail  @"BaiWang/GetInvoiceDetail"   //查询用户发票详情

#define GetExpStd     @"expuser/GetExpStd"   //获取费用标准
#define GetExpStdV2     @"expuser/GetExpStdV2"   //获取费用标准
#define GetInvPolicy     @"InvoiceType/GetInvPolicy"//查验发票

#define GetClientList   @"client/GetClientList" //获取客户列表
#define clientGetClientListByUserId   @"client/GetClientListByUserId"

#define GetBRCompany   @"Groupmbr/GetBranchList" //获取公司
#define GetBDivision   @"user/GetBusDepts" //获取业务部门
#define GetUSERDEPT   @"Groupmbr/GetGroupListByUserIdV2" //获取部门
#define GETBORROWFORM   @"Advance/GetAdvances" //获取借款单
#define GETTRAVELFORM   @"TravelApp/GetTravelForms" //获取出差申请单
#define GETFEEFORM   @"Fee/GetFeeForms" //获取费用申请单
#define GETPAYMENTCONTRACT   @"PaymentApp/GetContractForms" //获取合同
#define PaymentAppGetContractFormsV2   @"PaymentApp/GetContractFormsV2" //获取合同
#define PaymentAppGetContractFormsV3   @"PaymentApp/GetContractFormsV3" //获取合同
#define CancellationGetReimbursement   @"Cancellation/GetReimbursement" //获取合同
#define GETRELACONTRACT                @"ContractApp/GetRelateContContractPageData"//获取关联合同
//获取合同类型列表
#define GETCONTRACTTYPE @"ContractApp/GetContractTypesPaging"




#define GetPurchases   @"Purchase/GetPurchases"//获取采购申请单
#define GetADVANCETYPE  @"AdvanceType/GetAdvanceTypeList"//获取借款类型
#define GetLEAVETYPE  @"LeaveType/GetLeaveTypeList"//获取请假类型


#define DeleteClient   @"client/DeleteClient"

#define SaveClient   @"client/SaveClient"

#define GetClient   @"client/GetClient"

//************差旅/日常报销************/
//差旅报销页面打开
#define  travelReimrequestList @"travelexp/gettraveldata"
//差旅报销查看页面打开
#define  travelHasrequestList @"travelexp/getformdata"
//差旅报销查上传图片
#define  travelImgLoad @"travelexp/uploader"
//联系人页面打开
#define  travelReimContactrequestList @"travelexp/allusers"
//日常报销页面打开
#define  dailyReimrequestList @"dailyexp/gettraveldata"
//日常报销查看页面打开
#define  dailyHasrequestList @"dailyexp/getformdata"
//日常报销查上传图片
#define  dailyImgLoad @"dailyexp/uploader"

//保存
#define  SAVE      @"bpm/save"
//成本中心判断
//#define  CHECKTRAVEL     @"travelexp/verifybudget"
//#define  CHECKDAILY     @"dailyexp/verifybudget"
#define  CHECKTRAVEL     @"travelexp/verifybudget_v1"
#define  CHECKDAILY      @"dailyexp/verifybudget_v1"

//流程中验证预算
#define  BPMJUDGETBUDGET  @"bpm/JudgeBudget"
//提交
#define  SUBMIT    @"bpm/submit"
//同意
#define  APPROVAL  @"bpm/approve"
//退回
#define  RECEDE    @"bpm/Return"
//拒绝
#define  REJECT    @"bpm/reject"
//加签
#define  Endorse      @"bpm/EndorseMany"
//直送
#define  Direct      @"bpm/Direct"
//转交
#define  bpmDelegate      @"bpm/Delegate"
//抄送
#define  bpmCc     @"bpm/Cc"

/////*******************专项费用报销*************************/
// 获取专项费用类别接口
#define  GETOtherExpType    @"OtherExp/GetExpTyps"
// 获取专项费用报销表单数据(提交/保存)
#define  GETOtherExpData @"OtherExp/GetOtherExpData"
//获取专项费用申请表单数据(审批)
#define  GETOtherHasExpData @"OtherExp/GetFormData"
//获取是否有审批权限
#define GETApprovalAuth @"OtherExp/GetApprovalAuth"
//获取打印链接
#define GETPrintLink @"task/GetPrintLink"



//************买票************/
#define  ticketPlane  @"http://m.ctrip.com/webapp/flight/?allianceid=292076&sid=747920&sourceid=2055&popup=4&ouid="
#define  ticketTrain  @"http://m.ctrip.com/webapp/train/?allianceid=292076&sid=747920&sourceid=2055&popup=0&ouid="
#define  ticketHotel  @"http://m.ctrip.com/webapp/Hotel/?allianceid=292076&sid=747920&sourceid=2055&popup=0&ouid="


//************我的提交************/
#define submitGetNum                    @"tasknum/getcreatedbyme_v2"//任务数量
#define submitGetcreatedbyme            @"task/getcreatedbyme_v2"//我提交的
#define submitGetmydraft                @"task/getmydraft_v2"//未提交的
#define submitGetrecedeform             @"task/getrecedeform_v2"//退单
#define submitDeletedraft              @"bpm/deletedraft"//删除
#define SubmiterDelete                  @"bpm/Delete"//申请人删除
#define CANCELLEDDelete                    @"bpm/Discard"//申请人删除




//************我的审批************/
#define approvalGetNum        @"tasknum/getmytodo_v2"//任务数量
#define approvalWAITAPPROVAL  @"task/getmytodo_v2"//待审批
#define approvalHASAPPROVAL @"task/gethandledbyme_v2"//已审批
#define approvalWAITPAY @"task/getunpaid_v2"//待支付
#define approvalHASPAY @"task/getpaid_v2"//已支付
#define approvalAGREELIST @"bpm/batchapprove"//批量同意

#define GetReCallProcId  @"task/getprocidbyrecall"//获取撤回任务procId
#define JudgeRecall      @"bpm/canrecall"//判断是否可以撤回
#define RecallList       @"bpm/recall"//撤回操作

#define BPMURGE       @"bpm/Urge"//催办操作


#define ApproverEdit     @"task/IsEdit"//判断审批人查看页面是否可以编辑



//************审批记录************/

#define  approvalNotesRequestNotesList @"task/getproclist"


//************批量支付************/

#define BatchPayAGREELIST @"bpm/batchpayment"//批量批量支付
#define SinglePay  @"bpm/payment"//单条支付

#define PAYMENTDATE @"bpm/GetUnpaidCV2"//北京银行支付数据
#define PAYDO @"bpm/Pay"//北京银行支付数据
#define PAYProgress @"bpm/GetXbxPayHist"//获取支付进度
#define PAYAGAIN @"bpm/PayAgain"//再次支付
#define PAYQuerySingle @"bpm/QuerySingleTra"//获取单笔交易指令
#define PAYQueryMulti @"bpm/QueryMultiTra"//获取跨行代报销指令
#define PAYQueryDisMulti @"bpm/QueryDisMultiTra"//获取同行代报销指令



//************出差申请************/
#define addressGetcity @"travelapp/getallcities"
#define getcitys @"travelapp/getcities" //获取城市接口
#define getcitys_2 @"travelapp/getcities_v2"//获取城市+国际
#define getfromcity @"travelapp/oftenfromcities1"   //出差申请常用发出城市
#define gettocity   @"travelapp/oftentocities1"     //出差申请常用目的城市
#define gethotcities   @"travelapp/gethotcities1"//获取热门城市：POST string CityName =''
#define TravelAppGetCtripFlightCities   @"TravelApp/GetCtripFlightCities"
#define TravelAppGetCities_V4   @"TravelApp/GetCities_V4"

#define GETADDCOSTOFTENCITY @"expuser/GetOftenCities"   //获取记一笔选择酒店常用城市



//#define tr_Gettraveldata     @"travelapp/gettraveldata"//第一次打开表单和保存后打开表单接口
#define tr_GetTravelDataV2     @"travelapp/GetTravelDataV2"//第一次打开表单和保存后打开表单接口

//#define tr_Getformdata    @"travelapp/getformdata"
#define tr_GetformdataV2    @"travelapp/getformdataV2"

#define GetApprovalReason    @"task/GetApprovalReason"//获取退回审批意见

#define GetReturnProcList    @"task/GetReturnProcList"//获取退回人

//************借款************/
//付款申请表单数据(审批)接口

#define PaymentAppNewData    @"PaymentApp/GetPaymentData"

#define PaymentAppHasData    @"PaymentApp/GetFormData"

#define PaymentAppGetContractFormsByTaskId    @"PaymentApp/GetContractFormsByTaskId"
//获取收款单位列表
#define GetBeneficiary    @"PaymentApp/GetBeneficiary"

//删除收款单位
#define DeleteBeneficiary    @"PaymentApp/DeleteBeneficiary"

#define PaymentAppUploader    @"PaymentApp/uploader"

//保存收款单位列表
#define SaveBeneficiary    @"PaymentApp/SaveBeneficiary"

//付款预算控制
//#define VerifyPayBudget    @"PaymentApp/VerifyPayBudget"
#define VerifyPayBudget    @"ClaimLimit/Judge"

#define CLAIMBUDGET      @"ClaimLimit/GetLimitOutput"


//new付款
#define DeleteBeneficiary_B @"Beneficiary/DelBeneficiary"

#define SaveBeneficiary_B @"Beneficiary/SaveBeneficiary"

#define BeneficiaryList_B @"Beneficiary/BeneficiaryList"
#define BeneficiaryBeneficiaryListByUserId @"Beneficiary/BeneficiaryListByUserId"
#define GetVehicleInfos @"VehicleApp/GetVehicleInfos"

#define GetAreaList @"Area/GetAreaList"
#define GetLocationList @"Location/GetLocationList"

//************合同审批************/
#define GetContractAppData @"ContractApp/GetContractData"

#define ContractAppGetFormData @"ContractApp/GetFormData"


//************用车************/
#define GetVehicleAppData @"VehicleApp/GetVehicleData"
#define VehicleAppGetFormData @"VehicleApp/GetFormData"
#define VehicleAppIsUsed @"VehicleApp/IsUsered"

#define GetVehicleTyps @"VehicleApp/GetVehicleTyps"//获取用车类型
#define SaveVehicleInfo @"VehicleApp/SaveVehicleInfo"//保存车辆信息
#define DeleteVehicleInfo @"VehicleApp/DeleteVehicleInfo"//删除车辆信息
#define GetVehicleRecords @"VehicleApp/GetVehicleInfosAndReserveRecords"//获取车辆列表



//************加班************/
#define OvertimeGetFormData @"Overtime/GetFormData"
#define OvertimeGetOvertimeData @"Overtime/GetOvertimeData"
#define Overtimeuploader @"Overtime/uploader"

//************开票信息************/
#define NEWINVOICEAPPDATA  @"Invoice/GetInvoiceOutData"
#define HASINVOICEAPPDATA  @"Invoice/GetFormData"
#define Invoiceuploader @"Invoice/uploader"
#define GETINVOICEHISTORY @"Invoice/GetContractInvoice"
#define Invoiceuploader @"Invoice/uploader"

#pragma mark - 撤销申请单
#define NEWCANCELFLOW  @"Cancellation/GetCancellationData"
#define HASCANCELFLOW @"Cancellation/GetFormData"
#define Cancellationuploader @"Cancellation/uploader"


#pragma mark - 补打卡申请单
#define NEWWORKCARD @"WorkCard/GetWorkCardData"
#define HASWORKCARD @"WorkCard/GetFormData"
#define WorkCarduploader @"WorkCard/uploader"
#define WorkCardAllUsers @"WorkCard/AllUsers"
#define PerformanceAllUsers @"Performance/AllUsers"
#pragma mark - 考勤
#define AttendanceGetAttendances @"Attendance/GetAttendances"
#define AttendanceInsertAttendance @"Attendance/InsertAttendance"
#define AttendanceDeleteAttendance @"Attendance/DeleteAttendance"
#define AttendanceUpdateAttendance @"Attendance/UpdateAttendance"
#define AttendanceGetAttendance @"Attendance/GetAttendance"
#define AttendanceClockIn @"Attendance/ClockIn"
#define AttendanceGetAttendanceRpt @"Attendance/GetAttendanceRpt"

#define DriveCarGetDriveCarList @"DriveCar/GetDriveCarList"
#define DriveCarGetExpTypByDriveCar @"DriveCar/GetExpTypByDriveCar"
#define DriveImportDriveCar @"DriveCar/ImportDriveCar"
#define DriveCarImportBatchDriveCar @"DriveCar/ImportBatchDriveCar"
#define ExpuserImportBatchDriveCar @"expuser/ImportBatchDriveCar"

#define DidiGetExpTyp @"Didi/GetExpTyp"

#define DidiGetOrders @"Didi/GetOrders"

#define ExpuserImportBatchExp @"expuser/ImportBatchExp"
#define DriveCarImportDriveCar @"DriveCar/ImportDriveCar"
//差旅
//出差
//日常
//常用联系人
#define travelappallusers_v1            @"travelapp/allusers_v1"
#define travelexpallusers_v1            @"travelexp/allusers_v1"
#define leaveallusers            @"leave/allusers"
#define Purchaseallusers            @"Purchase/allusers"
#define dailyexpallusers_v1            @"dailyexp/allusers_v1"
#define leaveallusers            @"leave/allusers"
#define AdvanceAllUsers            @"Advance/AllUsers"
#define ItemAllUsers            @"Item/AllUsers"
#define CommontAllUsers            @"Commont/AllUsers"
#define PaymentAppAllUsers            @"PaymentApp/AllUsers"
#define RepaymentAllUsers            @"Repayment/AllUsers"
#define FeeAllUsers            @"Fee/AllUsers"
#define ContractAppAllUsers            @"ContractApp/AllUsers"
#define VehicleAppAllUsers            @"VehicleApp/AllUsers"
#define SealAllUsers            @"Seal/AllUsers"
#define StaffOutAllUsers            @"StaffOut/AllUsers"
#define OvertimeAllUsers            @"Overtime/AllUsers"
#define MeetingAllUsers            @"Meeting/AllUsers"
#define InvoiceAllUsers            @"Invoice/AllUsers"
#define CancellationAllUsers            @"Cancellation/AllUsers"


//************企业通讯录************/
//获取通讯录  连接 10.1.2.125 服务器  输入参数 int GroupId
#define getgroupmbr  @"groupmbr/getgroupmbr"
//user/contacts
//搜索通讯录  参数 string UserDspName
#define getmbrs @"groupmbr/getmbrs"

//获取父部门 级别
#define GetParentGroup @"groupmbr/GetParentGroup"

#define getnotactivatedusers     @"user/getnotactivatedusers"

#define getnewbieboard     @"user/getnewbieboard"

#pragma mark 代理接口
#define delegated_get     @"delegated/GetDlgts" //获取代理设置，无参数 POST
#define delegated_delete     @"delegated/delete" //删除，无参数 GET
#define delegated_getagents     @"delegated/getagents" //获取代理人列表，无参数 POST

//注销账户
#define logoutRequest @"user/cancellationaccount"

/* POST api/delegated save
 参数：
 int AgentUserId
 string AgentUserAccount
 string AgentUserName */
#define delegated_save     @"delegated/save" //保存代理人 POST

/* POST api/account/loginbyagent 登录
 string Account 被代申请人帐号
 int AgentUserId
 int UserId 当前登录人UserId*/
#define delegated_login    @"account/loginbyagent" //代理人登陆 POST

//************差旅************/
#define GETTRAVELNOTES @"travelapp/getmytravel"


//************费用************/
#define ReimburseGetTotol        @"expuser/GetExpsUserSUM"//获取消费记录汇总金额

//************工作************/
//我的审批
#define WorkapprovalGetNum        @"tasknum/getmytodo_v3"//@"tasknum/getmytodo_wk"//任务数量
#define WorkapprovalWAITAPPROVAL  @"task/getmytodo_v3"//@"task/getmytodo_wk"//待审批
#define WorkapprovalHASAPPROVAL   @"task/gethandledbyme_v3"//@"task/gethandledbyme_wk"//已审批
#define WorkapprovalCCTOME        @"task/GetCcToMe"//抄送给我


//我的申请
#define WorksubmitGetNum                    @"tasknum/getmydraft_v3"//@"tasknum/getcreatedbyme_wk"//任务数量
#define WorksubmitGetcreatedbyme            @"task/getcreatedbyme_v3"  //@"task/getcreatedbyme_wk"//我提交的
#define WorksubmitGetmydraft                @"task/getmydraft_v3"//@"task/getmydraft_wk"//未提交的

//请假
//请假页面打开
#define  AskingLeaverequestList    @"leave/getleavedata"
//请假上传图片
#define  AskingLeaveLoadImage      @"leave/uploader"
#define  HasAskedLeaveList        @"leave/getformdata"
//请假获取剩余假期
#define  AskedLeaveHolidayDays    @"LeaveType/GetHolidayDaysInfo"
//请假获取请假日历
#define  AskedLeaveCalendar    @"LeaveType/GetWorkCalendarByDate"


//借款
//借款页面打开
#define  AdvancerequestList    @"Advance/GetAdvanceData"
//借款上传图片
#define  AdvanceLoadImage      @"Advance/uploader"
#define  HasAdvanceList        @"Advance/GetFormData"

#define  GetTaskIdString        @"task/GetTaskIdString"

//物品领用
// POST api/Item/AllUsers  获取常用审批人
#define wp_AllUsers                    @"Item/AllUsers"
// POST api/Item/GetItemData 获取提交表单数据
#define wp_GetItemData                    @"Item/GetItemData"
// POST api/Item/GetFormData 获取审批表单数据
#define wp_GetFormData                    @"Item/GetFormData"
// POST api/Item/Uploader 上传图片
#define wp_Uploader                    @"Item/Uploader"
//物品领用验证库存
#define ITEMCHECKINVENTORY             @"bpm/IsStockAdequate"



//采购
//采购页面打开
#define  ProcurementrequestList    @"Purchase/GetPurchaseData"
//采购上传图片
#define  ProcurementLoadImage      @"Purchase/Uploader"
#define  HasProcurementList        @"Purchase/GetFormData"
//获取商品列表
#define  GETPURCHASEITEMS        @"Purchase/GetItems"
//删除商品
#define  DELLETEPURCHASE        @"Purchase/DeleteItem"
//保存商品
#define  SAVEPURCHASE        @"Purchase/SaveItem"
//获取商品类型列表
#define  GETPURCHASETYPELIST       @"Purchase/GetItemCatList"
//获取采购模板列表
#define  GETPURCHASETPLS         @"Purchase/GetItemTpls"
//获取id组商品列表
#define  GETPURCHASEITEMLIST      @"Purchase/GetItemListByIdList"


//通用审批
//通用审批页面打开
#define  CommontrequestList    @"Commont/GetCommontData"
//通用审批上传图片
#define  CommontLoadImage      @"Commont/uploader"
#define  HasCommontList        @"Commont/GetFormData"


//还款单
//还款单页面打开
#define  RepayrequestList    @"Repayment/GetRepaymentData"
//还款单上传图片
#define  RepayLoadImage      @"Repayment/uploader"
#define  HasRepayList        @"Repayment/GetFormData"

//费用申请单
//费用申请单页面打开
#define  FeeApprequestList    @"Fee/GetFeeData"
//费用申请单上传图片
#define  FeeAppLoadImage      @"Fee/uploader"

//费用申请单查看
#define  HasFeeAppList        @"Fee/GetFormData"


//用印
//用印申请单页面打开
#define  CHOPApprequestList    @"Seal/GetSealData"
//用印申请单上传图片
#define  CHOPAppLoadImage      @"Seal/uploader"
//用印申请单查看
#define  HasCHOPAppList        @"Seal/GetFormData"

//外出
//外出申请单页面打开
#define  STAFFOUTList        @"StaffOut/GetStaffOutData"
//外出申请单上传图片
#define  STAFFOUTLoadImage   @"StaffOut/uploader"
//外出申请单查看
#define  HasSTAFFOUTList        @"StaffOut/GetFormData"


//会议预定
//会议预定单页面打开
#define  MEETINGList        @"Meeting/GetMeetingData"
//会议预定上传图片
#define  MEETINGLoadImage   @"Meeting/uploader"
//会议预定单查看
#define  HasMEETINGList        @"Meeting/GetFormData"
//获取会议室列表
#define  MEETINGROOMList        @"Meeting/GetMeetingRooms"
//催款
#define  MESSAGEAMOUNT        @"Message/PressForMoneyAndInvoice"



//业务招待费
//业务招待费页面打开
#define  NEWENTERTAINMENT    @"Entertainment/GetEntertainmentData"
//业务招待费查看
#define  HASENTERTAINMENT    @"Entertainment/GetFormData"
//业务招待费常用审批人
#define  ENTERTAINMENTAllUsers    @"Entertainment/AllUsers"
//业务招待费修改申请人
#define  ENTERTAINMENTUserInfo    @"Entertainment/GetEntertainmentUserInfo"

//车辆维修
//车辆维修页面打开
#define  NEWVEHICLEREPAIR    @"VehicleSvc/GetVehicleSvcData"
//车辆维修费查看
#define  HASVEHICLEREPAIR    @"VehicleSvc/GetFormData"
//车辆维修常用审批人
#define  VEHICLEREPAIRAllUsers    @"VehicleSvc/AllUsers"
//车辆维修修改申请人
#define  VEHICLEREPAIRUserInfo    @"VehicleSvc/GetVehicleSvcUserInfo"

//获取业务招待或车辆维修
#define  GETENTERTAINVEHICLEFORMLIST    @"Entertainment/GetEntertainmentForms"

//根据id获取员工信息
#define  GETREQUESTORUSERINFO    @"Advance/GetAdvanceUserInfo"

//收款
//收款页面打开
#define  NEWRECEIPT   @"ReceiveBill/GetReceiveBillData"
//收款查看
#define  HASRECEIPT    @"ReceiveBill/GetFormData"
//收款常用审批人
#define  RECEIPTAllUsers    @"ReceiveBill/AllUsers"

//获取收款单列表
#define  GETRECEIVEBILLLIST  @"ReceiveBill/GetReceiveBillForms"
//根据合同获取收款信息
#define  GETRECEIVEBILLINFO  @"ReceiveBill/GetContractReceiveBill"

//供应商申请
//供应商申请页面打开
#define  NEWSUPPLIERAPPLY   @"Supplier/GetSupplierData"
//供应商申请查看
#define  HASSUPPLIERAPPLY    @"Supplier/GetFormData"
//供应商申请常用审批人
#define  SUPPLIERAPPLYAllUsers    @"Supplier/AllUsers"


//超标特殊事项
//申请页面打开
#define  NEWSPECIALREQUEST   @"SpecialRequirements/GetSpecialRequirementsData"
//申请查看
#define  HASSPECIALREQUEST    @"SpecialRequirements/GetFormData"
//申请常用审批人
#define  SPECIALREQUESTAllUsers    @"SpecialRequirements/AllUsers"



//员工外出培训
//申请页面打开
#define  NEWEMPLOYEETRAIN   @"EmployeeTraining/GetEmployeeTrainingData"
//申请查看
#define  HASEMPLOYEETRAIN    @"EmployeeTraining/GetFormData"
//申请常用审批人
#define  EMPLOYEETRAINAllUsers    @"EmployeeTraining/AllUsers"


//入库单
//申请页面打开
#define  NEWWAREHOUSEENTRY    @"Store/GetStoreData"
//申请查看
#define  HASWAREHOUSEENTRY    @"Store/GetFormData"
//申请常用审批人
#define  WAREHOUSEENTRYAllUsers  @"Store/AllUsers"

//发票登记
//申请页面打开
#define  NEWInvoiceReg    @"InvoiceRegApp/GetInvoiceRegData"
//申请查看
#define  HASInvoiceReg   @"InvoiceRegApp/GetFormData"
//申请常用审批人
#define  InvoiceRegAllUsers  @"InvoiceRegApp/AllUsers"


//结算单
//申请页面打开
#define  NEWSETTLEMENT    @"SettlementSlip/GetSettlementSlipData"
//申请查看
#define  HASSETTLEMENT @"SettlementSlip/GetFormData"
//申请常用审批人
#define  SettlementAllUsers  @"SettlementSlip/AllUsers"


//请款单
//申请页面打开
#define  NEWREMITTANCE    @"RemittanceApp/RemittanceAppData"
//申请查看
#define  HASREMITTANCE   @"RemittanceApp/GetFormData"
//申请常用审批人
#define  RemittanceAllUsers  @"RemittanceApp/AllUsers"








//补发票
//补发票页面打开
#define  NEWMAKEINVOICE    @"VehicleSvc/GetVehicleSvcData"
//补发票查看
#define  HASMAKEINVOICE    @"VehicleSvc/GetFormData"
//补发票常用审批人
#define  MAKEINVOICEAllUsers    @"VehicleSvc/AllUsers"


//获取开票申请单列表
#define  GETINVOICEFORMSLIST  @"Invoice/GetInvoiceForms"




//新建日程图片
#define  CaldanerImgLoad        @"Schedule/uploader"
//新建日程
#define  CaldanerInsert        @"Schedule/InsertSchedule"
//编辑日程
#define  CaldanerUpdate        @"Schedule/UpdateSchedule"
//删除日程
#define  CaldanerDelete        @"Schedule/DeleteSchedule"
//根据id获取日程信息
#define  CaldanerGET           @"Schedule/GetScheduleById"
//获取一个月的日程
#define  GETMONTHCaldaner      @"Schedule/GetDays"
//获取一个月的日程
#define  GETDAYCaldaner      @"Schedule/GetScheduleDays"
//获取(日程)同事列表
#define  GETCOLLCaldaner      @"Schedule/GetUsers"
//知会我的列表
#define  GETNOTIFYMECaldaner  @"Schedule/GetGetScheduleList"
//根据id获取日程
#define  GETCaldanerDETAIL  @"Schedule/GetScheduleById"

//获取绩效考核类型
#define  GETPERTYPE     @"Performance/GetPerformanceTypes"

#define  GETPERNERFORM  @"Performance/GetPerformanceData"
#define  GETPERHASFORM  @"Performance/GetFormData"
#define  UPLOADPERHASFORM  @"Performance/uploader"
#define  GETPERFORMANCEREQ  @"Performance/GetPerformanceUserInfo"


//公告
#define  GetAllNoticesList  @"Notices/GetAllNoticesList"
#define  GetNoticesList     @"Notices/GetNoticesList"
#define  DELETENOTICES     @"Notices/DeleteNotices"
#define  GETNOTICESINFO     @"Notices/SeeNotices"
#define  INSERTNOTICES     @"Notices/InsertNotices"
#define  UPDATENOTICES     @"Notices/UpdateNotices"
#define  PRAISENOTICES     @"Notices/PraiseNotices"







//费用类别
#define  GETCATEList  @"exptyp/getexptypelist"
#define  SAVECATELIST @"exptyp/saveexptypelist"
#define  GETOFTENCATELIST @"exptyp/GetOftenExpType"//获取常用费用类别

//工作微应用数据获取
#define MicroAppGet            @"MicroApp/GetAll"
#define MicroAppGetCode        @"microapp/getcode"

//消息
//获取消息提醒消息
#define  Hist_GetAll        @"MsgHist/GetAll_V3"

//改变消息提醒消息状态
#define MessageIsRead     @"msghist/isread"

#define GETMESSAGEUNREAD  @"Message/GetMessageCountV2"



//删除消息
#define Messagedelete     @"MsgHist/delete"
//获取系统信息列表
#define  GetSystemMessageList        @"Message/GetSystemMessageList"

//获取消息列表信息
#define  GetMessageList        @"Message/GetMessageListV3"

//获取公告消息
#define  GETNOTICEALL        @"MsgHist/GetNoticeAll"




//报表列表数据
#define  GetReportMainData     @"StatisticsWk/Get"
#define  GetReportMainData_V1  @"StatisticsWk/GetRpts"



//费用统计chart
#define GetCostStatisticsChart          @"Statistics/GetStatisticsRptForm"

//预算统计chart
#define GetBudgetStatisticsChart        @"Statistics/GetBudgetRptForm"

//报销统计chart
#define GetApplyStatisticsChart         @"Statistics/GetDailyClaims"

//项目费用统计chart
#define GetProjectCostStatisticsChart   @"ProjCostAct/GetProjRptForm"

//员工费用统计chart
#define GetEmployeeCostStatisticsChart  @"RequestCostAct/GettRequestDailyList"

//单据查询chart
#define GetFormSearchChart              @"Task/GetDailyTasks"

//员工动向chart
#define GetEmployeeTrendChart           @"Statistics/GetEmployeeTrendsForm"

//请假统计chart
#define GetAskingLeaveStatisticsChart   @"StatisticsWk/GetLeavesForm"

//采购统计chart
#define GetProcurementStatisticsChart   @"StatisticsWk/GetDailyPurs"

//物品领用统计chart
#define GetArticleStatisticsChart       @"StatisticsWk/GetDailyItems"


/*******************************华住酒店*****************************/
//获取用户信息
#define HotelUserInfo  @"user/HzUserInfo"
//华住接口
//#define VCardID        @"100003521"
//#define SrcID          @"XIBAO"
//#define Secretkey      @"Y4STH52RJ0UDN1OI"
//#define HuaZhuServer   @"http://218.83.157.75:16647/"
//#define HuaZhuServer   @"http://tmc.h-world.com:8073/"
#define HuaZhuServer   @"https://tmc.h-world.com:9073/"
#define HotelUrl       @"Interface/QueryHotels"

#define HuaZhuServerTest   @"http://101.231.138.1:9199"


//未导入
#define NotLeadHotel     @"expuser/GetOrders"
//已导入
#define HasLeadHotel     @"expuser/GetImportedOrders"
#define LeadHotelCuston  @"expuser/InsertExp"

//携程单点登录获取单点登录信息
#define  CtripGetLogin   @"Ctrip/GetLoginModel"
//携程接口
#define  CtripLogIn   @"https://ct.ctrip.com/m/SingleSignOn/H5SignInfo"
#define CtripOrderDetail  @"Ctrip/GetOrderDetails"

#define CtripGetList  @"Ctrip/GetOrderList"
#define CtripGetDetail  @"Ctrip/GetOrderDetail"

#define CtripFlightORDER  @"Booking/InitTravelFlightUserBook"
#define CtripHotelORDER   @"Booking/InitTravelHotelUserBook"
#define CtripTrainORDER   @"Booking/InitTravelTrainUserBook"
#define CtripENDTRAVEL   @"Booking/TravelEnd"



//自定义字段获取数据源列表
#define GetMasterData  @"MasterData/GetMasterDataList"
/*******************************真格*****************************/

//获取Expense Type/Purpose
//接口参数 int ParentId （大类传0）
#define GETExpenseType  @"expuser/GetTypPurpsBox"

//获取Fapiao接口
#define GETFapiao       @"expuser/GetFapiaosBox"

//获取Project 接口
//接口参数 string ProjName 和分页接口
#define GETProject      @"proj/getProjs"

//修改记一笔时，根据id获取接口：
//接口参数 int id
#define EDITZGAddCost   @"expuser/GetDailyExpUserById"

//获取保存差旅设置
#define GetCtripSetting  @"CtripSetting/Get"
#define SaveCtripSetting @"CtripSetting/Save"

//保存自驾车信息
#define SaveSelfDrive @"DriveCar/SaveDriveCar"
#define UpdateSelfDrive @"DriveCar/UpdateDriveCar"


//滴滴出行
#define GETDIDICODE @"Didi/GetVerifyCode"
#define DIDIUserAuth @"Didi/UserAuth"

//百望云权限
#define BAIWOPEN @"BaiWCloud/GetInvoicePermission"

//微信卡包
#define WECHATCARDTOKEN @"WeiXinCard/GetAccessToken"
#define WECHATCARDAPI   @"WeiXinCard/GetApiTicket"
#define WECHATCARDSAVE  @"WeiXinCard/Save"

//发票管家
#define GETXBINVOICE @"XbxInvoice/GetXbxInvoice"
//获取微信卡包PDF地址
#define GETWECHATPDF @"WeiXinCard/GetWeiXinPDF"

//发送表单邮件
#define SENDFORMEMAIL @"Message/InsertMail"
//根据费用类别获取费用明细
#define GETDETAILEXP @"travelexp/GetDetailExpByExpCode"

//用户最近登录信息

#define GETLOGINHISTORY @"user/GetLoginLogDataByUserId"
//获取最近一条code
#define GETLASTCODE  @"client/GetLastCode"


//获取报销类型
#define GETREIMTYPES  @"ReimbursementType/GetReimbursementTypes"


//获取付款银行
#define GETPAYBANKNAME  @"PayAccess/GetPayAccessList"

//获取外出申请单
#define GETSTAFFOUT  @"StaffOut/GetStaffOutForms"

//获取特殊事项申请单
#define GETSPECIALREQUEST  @"SpecialRequirements/GetSpecialRequirementsForms"
//获取外出培训申请单
#define GETEMPLOYEETRAIN  @"EmployeeTraining/GeEmployeeTrainingsForms"
//获取收款人
#define GETALLPAYEE @"Payee/GetAllPayees"
//获取外部收款人
#define GETOUTSIDEPAYEE @"Payee/GetPayees"
//获取删除收款人
#define DELETEOUTSIDEPAYEE @"Payee/DeletePayee"
//获取编辑新增收款人
#define ADDEDITOUTSIDEPAYEE @"Payee/InsertPayee"

//获取用车申请单列表
#define GETVEHICLEFORM @"VehicleApp/GetVehicleForms"

//出差类型列表
#define GETBUSINESSTYPE @"TravelTyp/GetAll"


//库存列表
#define GETINVENTORYS @"Item/GetInventorys"


//获取其他类型的未提交费用
#define GETUSERUNSUBMITEXP  @"travelexp/GetExpUsers"

//导入未提交费用
#define IMPORTUSERUNSUBMITEXP  @"travelexp/ImportExpUsers"

//获取供应商类别
#define GETSUPPLIERCATS  @"Beneficiary/SupplierCats"

//获取付款单列表
#define GETPAYMENTFORMS  @"PaymentApp/GetPaymentForms"

//获取税率列表
#define GETTAXRATELIST  @"TaxRate/GetTaxRates"


//获取辅助核算项目列表
#define GETACCOUNTITEM  @"travelexp/GetExpenseActItems"

//获取自驾车路径
#define GETDRIVERCARROUTE @"DriveCar/GetDriveCarById"

//获取仓库列表
#define GETINVENTORYSTORAGES @"Inventory/InventoryStorages"

//获取入库单列表
#define GETSTOREAPPLIST @"Store/GeStoreForms"


//获取记一笔分摊信息
#define GETEXPSHAREDATE @"expuser/GetShareInfo"


//获取项目活动列表
#define GETPROJECTACTIVITY @"proj/ProjectActivity"

//获取币种
#define GETCURRENCYBOX @"currency/CurrencyBox"


//获取滴滴付款信息 OrdPayType 支付方式 默认全部，0-企业支付 1-个人垫付
#define GETDIDICORPINFO @"Didi/GetDidiCorpInfos"


//获取开户行
#define GETCLEARINGBANKS @"BankLineNo/GetClearingBanks"

//请求省份
#define GETPROVINCES @"BankLineNo/GetProvinces"

//请求城市
#define GETCITYS @"BankLineNo/GetCitys"

//请求城市
#define GETBANKOUTLETS @"BankLineNo/GetBankNames"


//滴滴订单
#define  DIDILOGIN   @"https://open.es.xiaojukeji.com/webapp/feESWebappLogin/index"

//滴滴出行单
#define  DIDICARORDER   @"travelapp/MyCarDetailList"

//根据cityCode获取滴滴城市Id
#define  GETDIDICITYIDBYCODE  @"travelapp/GetCityIdByCode"

//发票通OCR扫描识别
#define  FPTINVOICESCAN  @"GlorityOcr/Scan"

//是否开启分公司标准
#define  GETBRANCHSTDSET  @"Groupmbr/GetBranchStdSet"

//获取分公司列表
#define  GETBRANCHLIST  @"Groupmbr/GetBranchPageData"


//获取关联合同/申请单
#define GETRELATECONTANDAPPLY  @"PaymentApp/GetContractAndApplyData"


//出差类型新增修改
#define TRAVELTYPEADD     @"TravelTyp/Insert"
#define TRAVELTYPEUPDATE  @"TravelTyp/Update"

//分摊金额限制各个审批ID
#define GETCOSTSHAREAPPROVALID  @"travelexp/GetCostShareApprovalIds"


//获取付款导入明细列表
#define GETIMPORTPAYEXPLIST  @"PaymentApp/GetPayExpList"



//获取付款分摊部门汇总明细列表
#define GETPAYMENTSHAREDETAIL  @"PaymentApp/GetPaymentShareDetail"

//获取差旅一号单点登录配置项
#define TravelOneLogin @"client/Get517Ticket"//单点登录
#define GetTmcOrder    @"client/GetTmcOrder"//获取商旅出行
#define ImportAddNote @"expuser/ImportLa517"//导入记一笔
