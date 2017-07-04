//
//  CustomListTableViewCell.h
//  TextRecognitionDemo
//
//  Created by Admin on 16/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *docPic;
@property (weak, nonatomic) IBOutlet UILabel *docName;
@property (weak, nonatomic) IBOutlet UILabel *docDate;

@end
