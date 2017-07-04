//
//  documentDetailsViewController.h
//  TextRecognitionDemo
//
//  Created by Admin on 16/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface documentDetailsViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong)NSString *documentDetails;
@property (weak, nonatomic) IBOutlet UIImageView *docImage;
- (IBAction)backButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end
