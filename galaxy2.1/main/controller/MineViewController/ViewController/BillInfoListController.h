//
//  BillInfoListController.h
//  galaxy
//
//  Created by hfk on 2017/6/7.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "RootViewController.h"
@interface BillInfoListController : RootViewController<GPClientDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)BOOL CanDeal;//是否能操作
/**
 *  请求结果字典
 */
@property (nonatomic,strong)NSDictionary *resultDict;

@end
