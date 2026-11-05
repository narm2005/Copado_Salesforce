*** Settings ***
Documentation     Service Cloud: create a Case, then close it.
Resource          ../resources/common.resource
Suite Setup       Run Keywords    Setup Browser    AND    Login To Salesforce
Suite Teardown    End Suite

*** Test Cases ***
Create And Close Case
    [Tags]    regression    case
    ${suffix}=        Unique Suffix
    ${subject}=       Set Variable    CRT Case ${suffix}
    Open New Record Form    Case
    Select Lightning Picklist    Case Origin    Phone
    TypeText          Subject         ${subject}
    Save Record
    VerifyText        ${subject}
    # Close the case from the record page
    ClickText         Edit            partial_match=False
    Select Lightning Picklist    Status    Closed
    ClickText         Save            partial_match=False
    VerifyText        Closed
