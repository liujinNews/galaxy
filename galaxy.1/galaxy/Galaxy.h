//
//  Galaxy.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/13.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#ifndef Galaxy_h
#define Galaxy_h


#import "RootViewController.h"
#import "dockView.h"
#import "GPAlertView.h"
#import "GPUtils.h"
#import "GPClient.h"
#import "userData.h"
#import "GPRequestPaket.h"
#import "AppDelegate.h"
#import "chooseTravelDateView.h"
#import "YXSpritesLoadingView.h"
#import "NSString+StringSize.h"
#import "GkTextField.h"
#import "ZLPhoto.h"
#import "MJRefresh.h"
#import "NSString+Common.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "UIViewController+Push.h"
#import "UIBarButtonItem+Common.h"
#import "AFSessionSingleton.h"
#import "ChooseCateFreshController.h"
#import "approvalNoteModel.h"
#import "approvalNoteCell.h"
//出差申请F0001
#import "TravelRequestsViewController.h"
#import "LookTravelRequestsViewController.h"
//差旅F0002
#import "travelReimBusViewController.h"
#import "travelHasSubmitController.h"
#import "TravelAppoverController.h"
//日常F0003
#import "dailyReimViewController.h"
#import "dailyHasSumitViewController.h"
#import "DailyAppoverController.h"
//请假F0004
#import "AskingLeaveController.h"
#import "HasAskedLeaveController.h"
//采购F0005
#import "MyProcurementController.h"
#import "MyHasProcurementController.h"
//借款F0006
#import "MyAdvanceController.h"
#import "AdvanceHasSubmitController.h"
//物品领用F0007
#import "ItemRequestController.h"
#import "ItemHasRequestController.h"

//通用审批F0008
#import "MyGeneralApproveController.h"
#import "GeneralAppHasSubmitController.h"
//付款F0009
#import "MyPaymentNewController.h"
#import "MyPaymentHasController.h"
#import "MyPaymentApproveController.h"

//专项F0010
#import "OtherReimViewController.h"
#import "OtherReimHasViewController.h"
#import "OtherReimAppoverController.h"

//还款F0011
#import "RepaymentAppController.h"
#import "RepaymentAppHasController.h"
//费用申请F0012
#import "FeeAppController.h"
#import "FeeAppHasController.h"
//合同F0013
#import "ContractAppNewController.h"
#import "ContractAppHasController.h"
#import "ContractAppApproveController.h"



//用车F0014
#import "VehicleApplyNewController.h"
#import "VehicleApplyHasController.h"
#import "VehicleApplyApproveController.h"

//用印申请F0015
#import "MyChopController.h"
#import "MyChopHasController.h"

//外出申请
#import "OutGoingController.h"
#import "OutGoingHasController.h"
#import "OutGoingApproveController.h"


//加班申请F0017
#import "OverTimeNewViewController.h"
#import "OverTimeHasViewController.h"
#import "OverTimeApproveViewController.h"


//会议预订F0018
#import "ConferenceBookController.h"
#import "ConferenceBookHasController.h"

//开票申请 F0019
#import "InvoiceAppNewController.h"
#import "InvoiceAppHasController.h"

//撤销申请单 F0020
#import "CancelFlowNewController.h"
#import "CancelFlowHasController.h"

//补打卡单 F0021
#import "WorkCardNewController.h"
#import "WorkCardHasController.h"



//绩效 F0022
#import "PerformanceNewController.h"
#import "PerformanceHasController.h"

//业务招待 F0023
#import "EntertainmentNewController.h"
#import "EntertainmentHasController.h"


//车辆维修 F0024
#import "VehicleRepairNewController.h"
#import "VehicleRepairHasController.h"

//收款 F0025
#import "ReceiptNewController.h"
#import "ReceiptHasController.h"
//供应商 F0026
#import "SupplierApplyNewController.h"
#import "SupplierApplyHasController.h"
//超标特殊事项 F0027
#import "SpecialReqestNewController.h"
#import "SpecialReqestHasController.h"
//员工外出培训 F0028
#import "EmployeeTrainNewController.h"
#import "EmployeeTrainHasController.h"

//入库单
#import "WareHouseEntryNewController.h"
#import "WareHouseEntryHasController.h"
#import "WareHouseEntryApproveViewController.h"
//发票登记
#import "InvoiceRegisterNewController.h"
#import "InvoiceRegisterHasController.h"
#import "InvoiceRegisterApproveController.h"
//结算单
#import "StatementNewController.h"
#import "StatementHasController.h"
#import "StatementApproveController.h"
//请款单
#import "RemittanceNewController.h"
#import "RemittanceHasController.h"
#import "RemittanceApproveController.h"


//补发票 F0029
#import "MakeInvoiceNewController.h"
#import "MakeInvoiceHasController.h"

//考勤
#import "AttendanceViewController.h"

//退单、直送提交意见
#import "BackSubmitCommentController.h"
//发送邮件页面
#import "SendEmailViewController.h"

#import "UnReadManager.h"

#import "RootFlowWebViewController.h"

#endif /* Galaxy_h */
