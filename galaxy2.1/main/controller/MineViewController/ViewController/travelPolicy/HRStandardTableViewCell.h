//
//  HRStandardTableViewCell.h
//  galaxy
//
//  Created by 赵碚 on 16/5/10.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRStandardData.h"
@interface HRStandardTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong)UIView * mainView;
@property (nonatomic,strong)UIView * line;

-(void)configHRSTandardCellInfo:(HRStandardData *)cellInfo;

@property (nonatomic,strong)UIButton * tongBtn;
//@property (nonatomic,strong)GkTextField * hrandTF;

//补贴列表
-(void)configForStandardListCellInfo:(HRStandardData *)cellInfo;

//修改补贴
-(void)configForStandardCellInfo:(HRStandardData *)cellInfo;

//查看报销标准
-(void)configLookHRSTandardCellInfo:(HRStandardData *)cellInfo;
@end
