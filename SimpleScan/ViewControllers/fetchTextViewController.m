//
//  fetchTextViewController.m
//  TextRecognitionDemo
//
//  Created by Admin on 14/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import "fetchTextViewController.h"

@interface fetchTextViewController (){
    UIAlertView *textAlert;
}

@end

@implementation fetchTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    //[self performSelector:@selector(fetchText)];
    
   // [self fetchText];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:NO];
    [self performSelector:@selector(fetchText)];
}

-(void)fetchText{
    
        G8Tesseract *tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng+ita"];
    
        // Optionaly: You could specify engine to recognize with.
        // G8OCREngineModeTesseractOnly by default. It provides more features and faster
        // than Cube engine. See G8Constants.h for more information.
        tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    
        // Set up the delegate to receive Tesseract's callbacks.
        // self should respond to TesseractDelegate and implement a
        // "- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract"
        // method to receive a callback to decide whether or not to interrupt
        // Tesseract before it finishes a recognition.
        tesseract.delegate = self;
    
        // Optional: Limit the character set Tesseract should try to recognize from
       // tesseract.charWhitelist = @"@.(){}/\\!*&#0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
        // This is wrapper for common Tesseract variable kG8ParamTesseditCharWhitelist:
        // [tesseract setVariableValue:@"0123456789" forKey:kG8ParamTesseditCharBlacklist];
        // See G8TesseractParameters.h for a complete list of Tesseract variables
    
         //Optional: Limit the character set Tesseract should not try to recognize from
        //tesseract.charBlacklist = @"OoZzBbSs";
    
        // Specify the image Tesseract should recognize on
    
    
       tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;
       tesseract.engineMode  = G8OCREngineModeTesseractCubeCombined;
       tesseract.image = [_receivedImage g8_blackAndWhite];
    
        // Optional: Limit the area of the image Tesseract should recognize on to a rectangle
        //tesseract.rect = CGRectMake(20, 20, 100, 100);
    
        // Optional: Limit recognition time with a few seconds
        //    tesseract.maximumRecognitionTime = 2.0;
    
        // Start the recognition
    
        [tesseract recognize];
    
    
    // Retrieve the recognized text
    NSLog(@"recognized Text From Image = %@", [tesseract recognizedText]);
    NSString *fetchedText = [tesseract recognizedText];
    NSString *finalText = [fetchedText stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
        
    _textView.text = finalText;
    
    if ([_textView.text isEqualToString:@""]) {
        textAlert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                  message:[NSString stringWithFormat:@"Text not found."]
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
        [textAlert show];
    }
    [self.activityIndicator stopAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)shareAction:(id)sender {
    [self shareText:_textView.text andImage:nil andUrl:nil];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url
{
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if (text) {
        [sharingItems addObject:text];
    }
    if (image) {
        [sharingItems addObject:image];
    }
    if (url) {
        [sharingItems addObject:url];
    }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == textAlert && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
   

@end
