//
//  ChooseTypeController.h
//  galaxy
//
//  Created by hfk on 2017/6/27.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import "FlowBaseViewController.h"

@interface ChooseTypeController : FlowBaseViewController<GPClientDelegate>
@property (assign, nonatomic)NSInteger totalPages;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)ChooseCategoryCell *cell;
@property(nonatomic,strong)NSString *ChooseCategoryId;
@property(nonatomic,strong)NSMutableArray *ChoosedIdArray;
@property (nonatomic, strong) UIView *dockView;//底部视图
@property (nonatomic,copy) void(^ChooseCateBlock)(ChooseCateFreModel *model, NSString *type);
-(id)initWithType:(NSString *)type;
@end
