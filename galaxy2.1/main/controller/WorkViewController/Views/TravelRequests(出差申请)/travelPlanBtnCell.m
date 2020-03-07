//
//  travelPlanBtnCell.m
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "travelPlanBtnCell.h"
#import "GPUtils.h"


@interface travelPlanBtnCell()

@property (nonatomic, strong)NSMutableArray *arraylist;//数据显示


@end

@implementation travelPlanBtnCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self!=nil) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

-(travelPlanBtnCell *)initModelwithView:(NSString *)name value:(NSString *)value type:(NSString *)type
{
    self.type = [[NSString alloc]initWithString:type];
    travelPlanBtnCell *cell = [[travelPlanBtnCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    //灰色带
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    [cell addSubview:view];
    
    cell.lab_title = [GPUtils createLable:CGRectMake(15, 23, 120, 20) text:name font:Font_Important_15_20 textColor:[GPUtils colorHString:LableColor] textAlignment:NSTextAlignmentLeft];
    
    cell.lab_content = [GPUtils createLable:CGRectMake(Main_Screen_Width/2-35, 23, Main_Screen_Width/2, 20) text:value font:Font_Important_15_20 textColor:Color_form_TextField_20 textAlignment:NSTextAlignmentRight];
    
    cell.images = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"skipImage"]];
    [cell.images setFrame:CGRectMake(Main_Screen_Width-25, 25, 15, 15)];
    
//    cell.btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    
    [cell addSubview:cell.images];
    [cell addSubview:cell.lab_content];
    [cell addSubview:cell.lab_title];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



@end
