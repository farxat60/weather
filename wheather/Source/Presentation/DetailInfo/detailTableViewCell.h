//
//  detailTableViewCell.h
//  wheather
//
//  Created by Joe Franc on 10/27/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailTableViewCell : UITableViewCell  
@property (strong, nonatomic) IBOutlet UILabel *tempDetailLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imageDetail;
@property (strong, nonatomic) IBOutlet UIImageView *imageC;
@property (strong, nonatomic) IBOutlet UILabel *txtDateil;
@end
