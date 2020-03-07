//
//  ExmineApproveView.h
//  galaxy
//
//  Created by 贺一鸣 on 2017/12/25.
//  Copyright © 2017年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ExmineBlock)(NSMutableArray *arr);

@interface ExmineApproveView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

-(ExmineApproveView *)initWithBaseView:(UIView *)baseView Withmodel:(MyProcurementModel *)model WithInfodict:(NSDictionary *)dict;

@property (nonatomic, strong) NSMutableArray *arr_Main;
@property (nonatomic, strong) NSMutableArray *arr_Result;

@end
