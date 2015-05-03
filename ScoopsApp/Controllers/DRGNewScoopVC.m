//
//  DRGNewScoopVC.m
//  ScoopsApp
//
//  Created by David Regatos on 29/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGNewScoopVC.h"
#import "DRGAzureManager.h"
#import "DRGScoop.h"
#import "DRGUser.h"
#import "UIImageView+AsyncDownload.h"
#import "UIImage+Resize.h"

#define HEADLINE_TAG    100
#define LEAD_TAG        101
#define BODY_TAG        102

#define HEIGHT_TOP_CONTAINER 120
#define HEIGHT_BAR_BOTTOM    44

@interface DRGNewScoopVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) float initialHeight;

@property (nonatomic, strong) UIImage *photo;

@end

@implementation DRGNewScoopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self syncViewAndModel];
    
    // Autolayout
    [self applyInitialLayout];
        
    // Notifications **********************
    [self registerForNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unregisterForNotifications];   //optionally we can unregister a notification when the view disappears
}

#pragma mark - NSNotification

- (void)dealloc {
    [self unregisterForNotifications];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)unregisterForNotifications {
    // Clear out _all_ observations that this object was making
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// UIKeyboardWillShowNotification
- (void)notifyKeyboardWillShow:(NSNotification *)notification {
    
    if (self.authorTextField.isFirstResponder) {
        return;
    }
    
    // Sacar tamaño del teclado del userinfo de la notification
    NSDictionary *kbInfo = notification.userInfo;
    NSValue *wrappedFrame = [kbInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect kbFrame = [wrappedFrame CGRectValue];
    
    [self.view setNeedsLayout];
    CGFloat heightView = self.view.bounds.size.height;
    CGFloat heightViewMinusKeyboard = heightView - kbFrame.size.height;
    self.heightTopContainerViewConstrain.constant = 0;
    self.heightBottomBarConstrain.constant = HEIGHT_BAR_BOTTOM + kbFrame.size.height;
    
    if (self.headlineTextView.isFirstResponder) {
        
        self.heigthHeadlineConstrain.constant = heightViewMinusKeyboard; // - self.headlineTextView.frame.origin.y;
        self.heightLeadConstrain.constant = 0;
        self.leadTextView.alpha = 0;
        self.heightBodyConstrain.constant = 0;
        self.bodyTextView.alpha = 0;

    } else if (self.leadTextView.isFirstResponder) {
        
        self.heigthHeadlineConstrain.constant = 0;
        self.headlineTextView.alpha = 0;
        self.heightLeadConstrain.constant = heightViewMinusKeyboard; // - self.leadTextView.frame.origin.y;
        self.heightBodyConstrain.constant = 0;
        self.bodyTextView.alpha = 0;
        
    } else if (self.bodyTextView.isFirstResponder) {
        
        self.heigthHeadlineConstrain.constant = 0;
        self.headlineTextView.alpha = 0;
        self.heightLeadConstrain.constant = 0;
        self.leadTextView.alpha = 0;
        self.heightBodyConstrain.constant = heightViewMinusKeyboard; // - self.bodyTextView.frame.origin.y;
    }
    
    // Sacar la duración de la animación del teclado
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.topContainer.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

// UIKeyboardWillHideNotification
- (void)notifyKeyboardWillHide:(NSNotification *)notification {
    
    if (!self.authorTextField.isFirstResponder) {
        // Deshacer todo lo modificado en notifyKeyboardWillShow con animacións
        // Sacar la duración de la animación del teclado
        double duration = [[notification.userInfo
                            objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [self.view setNeedsLayout];
        [self applyInitialLayout];
        [UIView animateWithDuration:duration animations:^{
            self.topContainer.alpha = 1;
            self.headlineTextView.alpha = 1;
            self.leadTextView.alpha = 1;
            self.bodyTextView.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (void)applyInitialLayout {
    CGFloat heightView = self.view.bounds.size.height;
    self.heightTopContainerViewConstrain.constant = HEIGHT_TOP_CONTAINER;
    self.heightBottomBarConstrain.constant = HEIGHT_BAR_BOTTOM;
    self.initialHeight = (heightView - HEIGHT_TOP_CONTAINER - HEIGHT_BAR_BOTTOM)/3;
    self.heigthHeadlineConstrain.constant = self.initialHeight;
    self.heightLeadConstrain.constant = self.initialHeight;
    self.heightBodyConstrain.constant = self.initialHeight;
}

#pragma mark - IBActions

- (IBAction)hideKeyboard:(UIControl *)sender {
    [self.view endEditing:YES];
}

- (IBAction)cancenBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBtnPressed:(id)sender {
    
    if (!self.scoop) {
        self.scoop = [DRGScoop scoopWithHeadline:self.headlineTextView.text
                                            lead:self.leadTextView.text
                                            body:self.bodyTextView.text
                                        authorId:nil
                                      authorName:self.authorTextField.text
                                       published:self.publishSwitch.on];
    } else {
        self.scoop.authorName = self.authorTextField.text;
        self.scoop.headline = self.headlineTextView.text;
        self.scoop.lead = self.leadTextView.text;
        self.scoop.body = self.bodyTextView.text;
        self.scoop.published = self.publishSwitch.on;
    }
    
    [[DRGAzureManager sharedInstance] uploadScoop:self.scoop withCompletion:^(DRGScoop *scoop, NSError *error) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription];
        } else if (!scoop) {
            [self showAlertWithMessage:@"Houston, we had a problem!!"];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
        //[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)photoImageTapped:(UITapGestureRecognizer *)sender {
    if (!self.photo) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // ask user if he wants to take a new picture or use an existing one.
            [self askForTakingPhotoOrPickFromLibrary];
        } else {
            [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    } else {
        [self deleteCurrentPicture];
    }
}

#pragma mark - UIImagePickerController

- (void)launchImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         // Cuando termine la animación que muestra el picker
                         // se ejecutará este bloque.
                     }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    __block UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.height * screenScale, screenBounds.size.width * screenScale);
    
//    [self.photoActivityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        img = [img resizedImage:screenSize interpolationQuality:kCGInterpolationMedium];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photo = img;
            self.photoImageView.image = img;
//            [self.photoActivityIndicator stopAnimating];
        });
    });
    
    // Ocultar el presented VC
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Cuando termine la animación que oculta el picker
                                 // se ejecutará este bloque.
                             }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    // Ocultar el presented VC
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Cuando termine la animación que oculta el picker
                                 // se ejecutará este bloque.
                             }];
}

#pragma mark - Alert controller

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okBtn = [UIAlertAction actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action) {
                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                  }];
    [alert addAction:okBtn];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)askForTakingPhotoOrPickFromLibrary {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to...?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *photoBtn = [UIAlertAction actionWithTitle:@"Take a picture"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                                                         ;
                                                     }];
    UIAlertAction *libraryBtn = [UIAlertAction actionWithTitle:@"Select one from Library"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [self launchImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                           ;
                                                       }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style: UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];
    [alert addAction:photoBtn];
    [alert addAction:libraryBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteCurrentPicture {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to remove current photo?"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *removeBtn = [UIAlertAction actionWithTitle:@"YES"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          self.photo = nil;
                                                          self.photoImageView.image = [UIImage imageNamed:@"image_placeholder"];
                                                      }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"No"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {
                                                          [alert dismissViewControllerAnimated:YES completion:nil];
                                                      }];
    [alert addAction:removeBtn];
    [alert addAction:cancelBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Utils

- (void)syncViewAndModel {
    self.authorTextField.text = self.scoop.authorName ? self.scoop.authorName : self.user.name;
    self.headlineTextView.text = self.scoop.headline;
    self.leadTextView.text = self.scoop.lead;
    self.bodyTextView.text = self.scoop.body;
    self.photoImageView.clipsToBounds = YES;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.scoop.photo) {
        self.photo = self.scoop.photo;
        self.photoImageView.image = self.scoop.photo;
//        [self.photoImageView asyncDownloadFromURL:self.scoop.photoURL];
    } else {
        self.photo = nil;
        self.photoImageView.image = [UIImage imageNamed:@"image_placeholder"];
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

@end
