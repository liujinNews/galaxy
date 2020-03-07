//
//  ElectInvoiceCell.h
//  galaxy
//
//  Created by 赵碚 on 2016/12/21.
//  Copyright © 2016年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ElectInvoiceData.h"

@interface ElectInvoiceCell : UITableViewCell
@property (nonatomic, strong) UIView *mainView;

- (void)configViewWithElectResultCellInfo:(ElectInvoiceData *)cellInfo;

//电子发票列表
@property (nonatomic,strong)UIImageView * selectedImage;
-(void)configElectListCellTypeSelected:(NSDictionary*)cellInfo;

//企业电子发票列表
-(void)configCompanyElectListCellTypeSelected:(NSDictionary*)cellInfo;
@end
