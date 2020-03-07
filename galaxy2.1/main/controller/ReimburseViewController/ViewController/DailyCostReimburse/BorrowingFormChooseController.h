//
//  BorrowingFormChooseController.h
//  galaxy
//
//  Created by hfk on 16/8/5.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"
#import "ChooseCateFreModel.h"
#import "BorrowFormCell.h"


@interface BorrowingFormChooseController : FlowBaseViewController<GPClientDelegate,UISearchBarDelegate>

@property (assign, nonatomic)NSInteger totalPages;
@property(nonatomic,strong)BorrowFormCell *cell;
@property(nonatomic,strong)NSString *ChooseCategoryId;
@property(nonatomic,strong)NSMutableArray *ChoosedIdArray;
@property (nonatomic, strong) NSDictionary *dict_otherPars;
@property (nonatomic, copy) NSString *str_ReversalType;
@property (nonatomic,copy) void(^ChooseBorrowFormBlock)(NSMutableArray *array, NSString *reversalType);

@end

