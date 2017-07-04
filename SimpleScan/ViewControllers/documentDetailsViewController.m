//
//  documentDetailsViewController.m
//  TextRecognitionDemo
//
//  Created by Admin on 16/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import "documentDetailsViewController.h"
#import "fetchTextViewController.h"
#import "getPDFViewController.h"

@interface documentDetailsViewController ()

@end

@implementation documentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger index = _documentDetails.length - 13 ;
    self.navigationItem.title = [_documentDetails substringToIndex:index];
    
    UIImage *receivedImage = [self getImageFromString:_documentDetails];
    
    UIImage *imageToDisplay =[UIImage imageWithCGImage:[receivedImage CGImage]
                                                 scale:1.0
                                           orientation: UIImageOrientationRight];
    
    UIImage *newImage=  [UIImage imageWithCGImage:[imageToDisplay CGImage]
                                            scale:1.0
                                      orientation: UIImageOrientationDown];
    
    
    UIImage *newImage2=  [UIImage imageWithCGImage:[newImage CGImage]
                                             scale:1.0
                                       orientation: UIImageOrientationLeft];
    _docImage.image = receivedImage;
    
    self.scrollview.minimumZoomScale = 0.5;
    self.scrollview.maximumZoomScale = 6.0;
    self.scrollview.contentSize = self.docImage.frame.size;
    self.scrollview.delegate = self;
    
     
    // Do any additional setup after loading the view.
}

#pragma mark UIScrollviewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.docImage;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}

-(UIImage *)getImageFromString:(NSString*)imgName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *folderPath = [documentsPath   stringByAppendingPathComponent:@"MyDocuments"];
    
    NSString *imagePath = [folderPath stringByAppendingPathComponent:imgName];
    UIImage *tempImage = [UIImage imageWithContentsOfFile:imagePath];
    return tempImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"FetchText"])
    {
        // Get reference to the destination view controller
        fetchTextViewController *vc = [segue destinationViewController];
        vc.receivedImage = self.docImage.image;
        
        // Pass any objects to the view controller here, like...
        
    }else if ([[segue identifier] isEqualToString:@"GetPDF"])
    {
        // Get reference to the destination view controller
        getPDFViewController *vc = [segue destinationViewController];
        vc.pdfImage = self.docImage.image;
        
        // Pass any objects to the view controller here, like...
        
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
