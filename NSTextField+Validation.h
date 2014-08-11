//
//  NSTextField+Validation.h
//
//  Created by Trent Milton on 02/07/2014.
//  Copyright (c) 2014 shaydes.dsgn. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum {
    ValidationTypeNone=0, // Default
    ValidationTypeEmail,
    ValidationTypePassword,
    ValidationTypeRequired,
    ValidationTypeOptional
} ValidationType;

@interface NSTextField (Validation)

@property (nonatomic) ValidationType validationType;
@property (nonatomic) NSString *placeholderString;

+ (void)setBackgroundColour:(NSColor *)colour;
+ (void)setValidBackgroundColour:(NSColor *)colour;
+ (void)setInvalidBackgroundColour:(NSColor *)colour;
+ (void)setPlaceholderValidateFontColour:(NSColor *)colour;
+ (void)setPlaceholderFontColour:(NSColor *)colour;

- (BOOL) validate;
- (void) reset;

@end
