*** Settings ***
Documentation     Sales Cloud: create an Account and verify it.
Resource          ../resources/common.resource
Suite Setup       Run Keywords    Setup Browser    AND    Login To Salesforce
Suite Teardown    End Suite

*** Test Cases ***
Create New Account
    [Tags]    smoke    regression    account
    ${suffix}=        Unique Suffix
    ${name}=          Set Variable    CRT Account ${suffix}
    Open New Record Form    Account
    TypeText          Account Name    ${name}
    TypeText          Phone           5852780000
    Save Record
    VerifyText        ${name}

Account Name Is Required
    [Tags]    regression    account    negative
    Open New Record Form    Account
    ClickText         Save    partial_match=False
    VerifyText        Complete this field
