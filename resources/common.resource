*** Settings ***
Documentation     Shared keywords for Salesforce tests (QWeb / Copado QWords style).
Library           QWeb
Library           DateTime

*** Variables ***
${LOGIN_URL}      %{SF_LOGIN_URL=https://login.salesforce.com}
${ORG_URL}        %{SF_ORG_URL}
${USERNAME}       %{SF_USERNAME}
${PASSWORD}       %{SF_PASSWORD}
${BROWSER}        %{BROWSER=chrome}
${TIMEOUT}        20s

*** Keywords ***
Setup Browser
    [Documentation]    Open the browser and set global QWeb behaviour.
    OpenBrowser       about:blank    ${BROWSER}
    SetConfig         DefaultTimeout    ${TIMEOUT}
    SetConfig         ShadowDOM         True          # Lightning uses shadow DOM

End Suite
    CloseAllBrowsers

Login To Salesforce
    [Documentation]    Log in with credentials from environment variables.
    GoTo              ${LOGIN_URL}
    TypeText          Username     ${USERNAME}
    TypeSecret        Password     ${PASSWORD}
    ClickText         Log In
    VerifyText        Home         timeout=60s

Open New Record Form
    [Arguments]       ${object_api_name}
    [Documentation]    Open the standard "New" form for an object, e.g. Account or Contact.
    GoTo              ${ORG_URL}/lightning/o/${object_api_name}/new
    VerifyText        Save         timeout=30s

Save Record
    ClickText         Save         partial_match=False
    VerifyText        was created  timeout=30s

Select Lightning Picklist
    [Arguments]       ${field_label}    ${value}
    [Documentation]    Lightning picklists are comboboxes, not HTML selects.
    ...                Open the combobox by its label, then click the option text.
    ClickElement      //button[@role="combobox" and @aria-label="${field_label}"]
    ClickElement      //lightning-base-combobox-item[@data-value="${value}"]

Unique Suffix
    [Documentation]    Timestamp so every run creates unique, independent data.
    ${ts}=            Get Current Date    result_format=%Y%m%d%H%M%S
    RETURN            ${ts}
