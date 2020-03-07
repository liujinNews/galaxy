//
//  travelPlanLabelCell.m
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import "travelPlanLabelCell.h"

@interface travelPlanLabelCell()<UITextFieldDelegate>

@end

@implementation travelPlanLabelCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self!=nil) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;;
    }
}

-(travelPlanLabelCell *)initModelwithView:(NSString *)name value:(NSString *)value type:(NSString *)type row:(NSInteger)row
{
    self.row = row;
    self.type = [[NSString alloc]initWithString:type];
    travelPlanLabelCell *cell = [[travelPlanLabelCell alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 55)];
    
    //灰色带
    UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 10)];
    view.backgroundColor=Color_White_Same_20;
    [cell addSubview:view];
    
    cell.lab_title = [GPUtils createLable:CGRectMake(15, 14, 70, 38) text:name font:Font_cellTitle_14 textColor:[GPUtils colorHString:LableColor] textAlignment:NSTextAlignmentLeft];
    cell.lab_title.numberOfLines = 2;
    
    if (row == 4) {
        cell.txf_content = [GPUtils createUITextView:CGRectMake(90, 17, Main_Screen_Width-105, 80) delegate:self font:Font_Important_15_20 textColor:Color_form_TextField_20 ];
        if ([NSString isEqualToNull:value]) {
            cell.txf_content.text = value;
        }
        else
        {
            cell.txf_content.text = Custing(@"请输入备注", nil);
        }
        
        cell.txf_content.tag = 5;
        [cell addSubview:cell.txf_content];
    }
    else
    {
        cell.lab_content = [GPUtils createTextField:CGRectMake(90, 23, Main_Screen_Width-95, 20) placeholder:@"" delegate:self font:Font_cellContent_16 textColor:[XBColorSupport supportScreenListColor]];
        cell.contentView.backgroundColor = Color_form_TextFieldBackgroundColor;
        if ([NSString isEqualToNull:value]) {
            cell.lab_content.placeholder = [NSString stringWithFormat:@"%@",value];
            [cell.lab_content setText:[NSString stringWithFormat:@"%@",value]];
        }
        cell.lab_content.tag = row;
        [cell addSubview:cell.lab_content];
    }
    
    
    [cell addSubview:cell.lab_title];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}




@end
