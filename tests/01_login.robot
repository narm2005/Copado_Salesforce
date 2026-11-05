*** Settings ***
Documentation     Smoke check: user can log in and reach Home.
Resource          ../resources/common.resource
Suite Setup       Setup Browser
Suite Teardown    End Suite

*** Test Cases ***
User Can Log In
    [Tags]    smoke    login
    Login To Salesforce
    VerifyText        Home
