//
//  ViewController.h
//  TextRecognitionDemo
//
//  Created by Admin on 13/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>
#import "VCFloatingActionButton.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,floatMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *docListTableview;
@property (weak, nonatomic) IBOutlet UIView *noDataView;


@end

