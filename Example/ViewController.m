//
//  ViewController.m
//  Example
//
//  Created by joshua li on 15/9/14.
//
//

#import "ViewController.h"

#import "XunFei.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onVoice:(id)sender {
    

    [[XunFei sharedInstance] initRecognizer:self.view];
    [[XunFei sharedInstance] start:^(NSString *result, NSError *error) {
        self.textView.text = result;
    }];
    

}
@end
