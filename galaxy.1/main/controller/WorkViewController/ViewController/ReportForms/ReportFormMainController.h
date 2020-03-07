//
//  ReportFormMainController.h
//  galaxy
//
//  Created by hfk on 16/5/9.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@interface ReportFormMainController : RootViewController<UITableViewDataSource,UITableViewDelegate,GPClientDelegate>
{
    //表格
    UITableView *_tableView;
    //是否正在加载
    BOOL _isLoading;
}
@property(assign,nonatomic)NSDictionary *resultDict;//下载成功字典
@property(nonatomic,strong)NSString *requestType;//请求类型
/**
 *  请求数据数组
 */
@property(nonatomic,strong)NSMutableArray *resultArray;
-(void)loadData;
-(id)initWithType:(NSString *)type;
@end
