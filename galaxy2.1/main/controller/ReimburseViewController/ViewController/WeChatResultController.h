//
//  WeChatResultController.h
//  galaxy
//
//  Created by hfk on 2017/10/17.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RootViewController.h"
#import "WeChatViewCell.h"
@interface WeChatResultController : RootViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataSoure;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)UITableView *tableView;

@end
