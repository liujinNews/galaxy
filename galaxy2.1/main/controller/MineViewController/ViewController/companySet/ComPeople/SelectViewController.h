//
//  SelectViewController.h
//  galaxy
//
//  Created by 贺一鸣 on 16/1/19.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "SelectDataModel.h"

@protocol SelectViewControllerDelegate <NSObject>

@optional
- (void)SelectViewControllerClickedLoadBtn:(SelectDataModel *)selectmodel;
@end

@interface SelectViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITableView *tab_table;

@property (nonatomic, assign) int type;//0 级别  1 职位  2 成本中心 3公司 4选择审批步骤 5业务部门 6合同类型 7合同审批单

@property (nonatomic, weak) id<SelectViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *FlowGuid;//选择审批步骤 流程GUID

@property (nonatomic, strong) NSString *selectId;//高亮内容id

@end
