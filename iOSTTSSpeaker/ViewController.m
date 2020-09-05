//
//  ViewController.m
//  Speech
//
//  Created by Han Mingjie on 2020/8/26.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "ViewController.h"
#import "TKTTSManager.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UITextView *textView;
    UIButton *playButton;
    
    UIPickerView *voiceLanguagePickerView;
    NSArray *avaliableLanguageArray;
}

@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    avaliableLanguageArray = [TKTTSManager avaliableLanguages];
}

-(void)play{
    [textView resignFirstResponder];
    
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    [u setValue:textView.text forKey:@"DefaultText"];
    [u synchronize];
    
    [TKTTSManager sharedInstance].voiceLanguage = [avaliableLanguageArray objectAtIndex:[voiceLanguagePickerView selectedRowInComponent:0]];
    [TKTTSManager sharedInstance].speakString = textView.text;
    [[TKTTSManager sharedInstance] startSpeak];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (nil == textView){
        textView = [[UITextView alloc] initWithFrame:CGRectMake(5.f, 60.f, self.view.frame.size.width-10.f, 200.f)];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        textView.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"DefaultText"];
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textView.layer.borderWidth = 2.f;
        [self.view addSubview:textView];
    }
    
    if (nil == voiceLanguagePickerView){
        voiceLanguagePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5.f, CGRectGetMaxY(textView.frame), self.view.frame.size.width-10.f, 200.f)];
        voiceLanguagePickerView.dataSource = self;
        voiceLanguagePickerView.delegate = self;
        [self.view addSubview:voiceLanguagePickerView];
        
        NSString *ss = [TKTTSManager currentLanguage];
        for (int i=0;i<avaliableLanguageArray.count;i++){
            if ([ss isEqualToString:[avaliableLanguageArray objectAtIndex:i]]){
                [voiceLanguagePickerView selectRow:i inComponent:0 animated:YES];
                break;
            }
        }
        
    }

    
    if (nil == playButton){
        playButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100.f)/2.f, CGRectGetMaxY(voiceLanguagePickerView.frame)+5.f, 100.f, 40.f)];
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        [playButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:playButton];
    }
    return;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return avaliableLanguageArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [avaliableLanguageArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [textView resignFirstResponder];
}

@end
