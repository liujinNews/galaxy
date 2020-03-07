//
//  travelPlanLabelCell.h
//  galaxy
//
//  Created by 贺一鸣 on 15/11/11.
//  Copyright © 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol travelPlanLabelCellDelegate <NSObject>
@optional
- (void)travelPlanLabelCellClickedLoadBtn:(NSString *)content row:(NSInteger )row type:(NSString *)type;
@end

@interface travelPlanLabelCell : UITableViewCell

@property (nonatomic,strong)UILabel  * lab_title;
@property (nonatomic,strong)UITextField  * lab_content;

@property (nonatomic, strong)UITextView *txf_content;

@property (nonatomic,strong)UIDatePicker  * datePicker;
@property (nonatomic,copy) NSString *type;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic, weak)id<travelPlanLabelCellDelegate>delegate;

-(travelPlanLabelCell *)initModelwithView:(NSString *)name value:(NSString *)value type:(NSString *)type row:(NSInteger )row;

@end
