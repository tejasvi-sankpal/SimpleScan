//
//  ScannerViewController.m
//  TextRecognitionDemo
//
//  Created by Admin on 14/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import "ScannerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PDFImageConverter.h"
#import "fetchTextViewController.h"
#import "getPDFViewController.h"
#import "UIColor+UIColor_TPAdditions.h"


@interface ScannerViewController ()

@end

@implementation ScannerViewController

UIAlertView *successAlert;
UIAlertView *failureAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imageCropView.image = [UIImage imageNamed:@"pict.jpeg"];
    imageCropView.controlColor = [UIColor cyanColor];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [imagePicker.navigationBar setBarTintColor:[UIColor loginNavThemeColor]];
        [imagePicker.navigationBar setTintColor:[UIColor whiteColor]];
        imagePicker.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor loginNavTextColor] forKey:NSForegroundColorAttributeName];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

    

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
        vc.receivedImage = self.imageView.image;
        
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

- (IBAction)fetchTextButtonAction:(id)sender {
}

- (IBAction)getPDFButtonAction:(id)sender {
}

- (IBAction)takeButtonAction:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        [imagePicker.navigationBar setBarTintColor:[UIColor loginNavThemeColor]];
        [imagePicker.navigationBar setTintColor:[UIColor whiteColor]];
        imagePicker.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor loginNavTextColor] forKey:NSForegroundColorAttributeName];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Your device doesn't have a camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }

}

- (IBAction)ChooseButtonAction:(id)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    [imagePickerController.navigationBar setBarTintColor:[UIColor loginNavThemeColor]];
    [imagePickerController.navigationBar setTintColor:[UIColor whiteColor]];
    imagePickerController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor loginNavTextColor] forKey:NSForegroundColorAttributeName];
    [self presentViewController:imagePickerController animated:YES completion:nil];

}

- (IBAction)cropButtonAction:(id)sender {
    
    if(capturedimage != nil){
        ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:capturedimage];
        controller.delegate = self;
        controller.blurredBackground = YES;
        // set the cropped area
        // controller.cropArea = CGRectMake(0, 0, 100, 200);
        [[self navigationController] pushViewController:controller animated:YES];
    }else{
        [self emptyImageAlert];
    }

}

- (IBAction)saveButtonAction:(id)sender {
    
    if(capturedimage != nil){
    
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSString *nameStr = @"New Doc";
        NSString *documentName = [NSString stringWithFormat:@"%@ %@",nameStr,dateString];
        // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
        NSLog(@"documentName = %@",documentName);
        
        UIImage *image = capturedimage; // imageView is my image from camera
        //NSData *imageData = UIImagePNGRepresentation(image);
        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *folderPath = [documentsDirectoryPath  stringByAppendingPathComponent:@"MyDocuments"];  // subDirectory
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
            
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath  withIntermediateDirectories:NO attributes:nil error:nil];
        //Add the FileName to FilePath
        
        NSString *filePath = [folderPath stringByAppendingPathComponent:[documentName stringByAppendingFormat:@"%@",@".jpeg"]];
        [imageData writeToFile:filePath atomically:YES];
        
        successAlert = [[UIAlertView alloc] initWithTitle:@"Succes!"
                                                  message:@"Saved to Device"
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
        [successAlert show];
        
    }else{
        [self emptyImageAlert];
    }
}

- (IBAction)backButtonAction:(id)sender {
    
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButtonAction:(id)sender {
    if(capturedimage != nil){
        
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:capturedimage];
        editor.delegate = self;
        
        [self presentViewController:editor animated:YES completion:nil];
        
//        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:capturedimage delegate:self];
//        editor.delegate = self;
//        //CLImageEditor *editor = [[CLImageEditor alloc] initWithDelegate:self];
//        
//        /*
//         NSLog(@"%@", editor.toolInfo);
//         NSLog(@"%@", editor.toolInfo.toolTreeDescription);
//         
//         CLImageToolInfo *tool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:NO];
//         tool.available = NO;
//         
//         tool = [editor.toolInfo subToolInfoWithToolName:@"CLRotateTool" recursive:YES];
//         tool.available = NO;
//         
//         tool = [editor.toolInfo subToolInfoWithToolName:@"CLHueEffect" recursive:YES];
//         tool.available = NO;
//         */
//        
//        [self presentViewController:editor animated:YES completion:nil];
//        
//        //[self.navigationController pushViewController:editor animated:YES];
//        //[editor showInViewController:self withImageView:_imageView];
        
    }else{
        [self emptyImageAlert];
    }
}
    
-(void)emptyImageAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                              message:@"Please scan any document or choose from gallary."
                                             delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [alert show];
}

#pragma mark UIImagePickerViewControllerDelegate Methods

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * newImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    //_imageView.image = capturedimage;
    
    //UIImage *my300dpiImage = [UIImage imageWithCGImage:capturedimage.CGImage scale:300.0f/72.0f orientation:UIImageOrientationRight] ;
    capturedimage = [self convertImageToGrayScale:newImage];
    
    _imageView.image = capturedimage;
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:capturedimage];
    editor.delegate = self;
    
    [picker presentViewController:editor animated:YES completion:nil];
}
    
- (UIImage *)processUsingCoreGraphics:(UIImage*)input {
        CGRect imageRect = {CGPointZero,input.size};
        NSInteger inputWidth = CGRectGetWidth(imageRect);
        NSInteger inputHeight = CGRectGetHeight(imageRect);
        
        // 1) Calculate the location of Ghosty
        UIImage * ghostImage = _imageView.image;
        CGFloat ghostImageAspectRatio = ghostImage.size.width / ghostImage.size.height;
        
        NSInteger targetGhostWidth = inputWidth * 0.25;
        CGSize ghostSize = CGSizeMake(targetGhostWidth, targetGhostWidth / ghostImageAspectRatio);
        CGPoint ghostOrigin = CGPointMake(inputWidth * 0.5, inputHeight * 0.2);
        
        CGRect ghostRect = {ghostOrigin, ghostSize};
        
        // 2) Draw your image into the context.
        UIGraphicsBeginImageContext(input.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGAffineTransform flip = CGAffineTransformMakeScale(1.0, -1.0);
        CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip,0,-inputHeight);
        CGContextConcatCTM(context, flipThenShift);
        
        CGContextDrawImage(context, imageRect, [input CGImage]);
        
        CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
        CGContextSetAlpha(context,0.5);
        CGRect transformedGhostRect = CGRectApplyAffineTransform(ghostRect, flipThenShift);
        CGContextDrawImage(context, transformedGhostRect, [ghostImage CGImage]);
        
        // 3) Retrieve your processed image
        UIImage * imageWithGhost = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // 4) Draw your image into a grayscale context
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        context = CGBitmapContextCreate(nil, inputWidth, inputHeight,
                                        8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
        
        CGContextDrawImage(context, imageRect, [imageWithGhost CGImage]);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage * finalImage = [UIImage imageWithCGImage:imageRef];
        
        // 5) Cleanup
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        CFRelease(imageRef);
        
        return finalImage;
}
    
- (UIImage *)convertImageToGrayScale:(UIImage *)image
    {
        // Create image rectangle with current image width/height
        CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
        
        // Grayscale color space
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        // Create bitmap content with current image size and grayscale colorspace
        CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        
        // Draw image into current context, with specified rectangle
        // using previously defined context (with grayscale colorspace)
        CGContextDrawImage(context, imageRect, [image CGImage]);
        
        // Create bitmap image info from pixel data in current context
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        // Create a new UIImage object
        UIImage *newImage = [UIImage imageWithCGImage:imageRef];
        
        // Release colorspace, context and bitmap information
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        CFRelease(imageRef);
        
        // Return the new grayscale image
        //return newImage;
        return [UIImage imageWithCGImage:newImage.CGImage scale:300.0f/72.0f orientation:UIImageOrientationRight];
}
    

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
    
#pragma mark ImageCropViewControllerDelegate Methods

- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
    capturedimage = croppedImage;
    _imageView.image = croppedImage;
    CGRect cropArea = controller.cropArea;
    _imageView.image = [self imageWithImage:croppedImage scaledToSize:cropArea.size];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
    _imageView.image = capturedimage;
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        failureAlert = [[UIAlertView alloc] initWithTitle:@"Fail!"
                                                        message:[NSString stringWithFormat:@"Saved with error %@", error.description]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [failureAlert show];
        
    } else {
        successAlert = [[UIAlertView alloc] initWithTitle:@"Succes!"
                                                        message:@"Saved to camera roll"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [successAlert show];
        
    }
}

-(UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a bitmap context.
    UIGraphicsBeginImageContextWithOptions(newSize, YES, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
        
}
    
#pragma mark- CLImageEditor delegate
    
- (void)imageEditor:(CLImageEditor*)editor didFinishEdittingWithImage:(UIImage*)image{
    capturedimage = image;
    _imageView.image = capturedimage;
   
    [editor dismissViewControllerAnimated:YES completion:^{
        if ([self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
}
- (void)imageEditorDidCancel:(CLImageEditor*)editor{
    [editor dismissViewControllerAnimated:YES completion:^{
        if ([self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
 
}

#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == successAlert && buttonIndex == 0) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        getPDFViewController *pdfVC = [sb instantiateViewControllerWithIdentifier:@"GetPDFView"];
//        pdfVC.pdfImage = _imageView.image;
//        [self.navigationController pushViewController:pdfVC animated:YES];
    }
}


@end
