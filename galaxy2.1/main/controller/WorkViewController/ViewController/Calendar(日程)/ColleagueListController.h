//
//  ColleagueListController.h
//  galaxy
//
//  Created by hfk on 2018/1/18.
//  Copyright © 2018年 赵碚. All rights reserved.
//

#import "RootViewController.h"

@interface ColleagueListController : RootViewController<GPClientDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)NSMutableArray *arr_result;
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;


@end
