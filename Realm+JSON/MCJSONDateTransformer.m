//
//  MCJSONDateTransformer.m
//  RealmJSONDemo
//
//  Created by Matthew Cheok on 27/7/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import "MCJSONDateTransformer.h"

NSString * const MCJSONDateTimeTransformerName = @"MCJSONDateTimeTransformerName";
NSString * const MCJSONDateTimeMillisecondTransformerName = @"MCJSONDateTimeMillisecondTransformerName";
NSString * const MCJSONDateOnlyTransformerName = @"MCJSONDateOnlyTransformerName";
static NSString * const kDateFormatDateTime = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
static NSString * const kDateFormatDateTimeMillisecond = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ";
static NSString * const kDateFormatDateOnly = @"yyyy-MM-dd";

@interface MCJSONDateTransformer ()

@property (nonatomic, strong) NSDateFormatter * formatter;

@end

@implementation MCJSONDateTransformer

+ (void) load {
    [NSValueTransformer setValueTransformer:[[self alloc] initWithDateStyle:MCJSONDateTransformerStyleDateTime] forName:MCJSONDateTimeTransformerName];
    [NSValueTransformer setValueTransformer:[[self alloc] initWithDateStyle:MCJSONDateTransformerStyleDateTimeMillisecond] forName:MCJSONDateTimeMillisecondTransformerName];
    [NSValueTransformer setValueTransformer:[[self alloc] initWithDateStyle:MCJSONDateTransformerStyleDateOnly] forName:MCJSONDateOnlyTransformerName];
}

+ (void) setTransformer:(MCJSONDateTransformer * )transformer forDateStyle:(NSString *)style {
    [NSValueTransformer setValueTransformer:transformer forName:style];
}

+ (instancetype) valueTransformerWithDateStyle:(MCJSONDateTransformerStyle)style {
    return [[self alloc] initWithDateStyle:style];
}


- (instancetype) initWithDateFormat:(NSString * )stringFormat {
    self = [super init];
    if (self) {
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        self.formatter.dateFormat = stringFormat;
    }
    return self;
}

- (instancetype) initWithDateStyle:(MCJSONDateTransformerStyle)style {
    self = [super init];
    if (self) {
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        switch (style) {
            case MCJSONDateTransformerStyleDateOnly:
                self.formatter.dateFormat = kDateFormatDateOnly;
                break;
            case MCJSONDateTransformerStyleDateTimeMillisecond:
                self.formatter.dateFormat = kDateFormatDateTimeMillisecond;
                break;
                
            default:
                self.formatter.dateFormat = kDateFormatDateTime;
                break;
        }
    }
    return self;
}

+ (Class) transformedValueClass {
    return [NSDate class];
}

+ (BOOL) allowsReverseTransformation {
    return YES;
}

- (id) transformedValue:(id)value {
    if (!value || value == [NSNull null]) {
        return nil;
    }
    return [self.formatter dateFromString:value];
}

- (id) reverseTransformedValue:(id)value {
    return [self.formatter stringFromDate:value];
}

@end
